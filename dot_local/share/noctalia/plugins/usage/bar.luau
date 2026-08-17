--!nonstrict

local REFRESH_INTERVAL_MS = 300000
local providers = {
  { key = "codex", label = "Codex", glyph = "brand-openai", color = "primary" },
  { key = "claude", label = "Claude", glyph = "message-chatbot-filled", color = "tertiary" },
}
local refreshing = false
local snapshot = nil

local function percent(value)
  return string.format("%d%%", math.floor((tonumber(value) or 0) + 0.5))
end

local function resetTime(value)
  if type(value) == "string" then
    return value:gsub("T", " "):sub(1, 16)
  end
  return "unknown"
end

local function providerText(provider)
  local values = {}
  for _, window in ipairs(provider.windows or {}) do
    values[#values + 1] = percent(window.usedPercent)
  end
  if #values == 0 then
    return "--"
  end
  return table.concat(values, "/")
end

local function render()
  if refreshing and snapshot == nil then
    barWidget.render(ui.row({ align = "center", gap = 5 }, {
      ui.glyph({ name = "loader-2", size = 13, color = "primary" }),
      ui.label({ text = "…", fontSize = 11, color = "on_surface" }),
    }))
    barWidget.setTooltip("Loading Codex and Claude usage")
    return
  end
  if type(snapshot) ~= "table" then
    barWidget.render(ui.glyph({ name = "alert-circle", size = 13, color = "error" }))
    barWidget.setTooltip("AI usage is unavailable")
    return
  end

  local segments = {}
  local tooltip = {}
  for index, spec in ipairs(providers) do
    local provider = snapshot[spec.key] or {}
    if index > 1 then
      segments[#segments + 1] = ui.box({ width = 1, height = 15, fill = "outline/0.35" })
    end
    segments[#segments + 1] = ui.row({ align = "center", gap = 4 }, {
      ui.glyph({ name = spec.glyph, size = 13, color = spec.color }),
      ui.label({
        text = providerText(provider),
        fontSize = 11,
        fontWeight = "semibold",
        color = "on_surface",
        maxLines = 1,
      }),
    })
    if provider.error then
      tooltip[#tooltip + 1] = spec.label .. ": " .. tostring(provider.error)
    else
      local lines = { spec.label }
      for _, window in ipairs(provider.windows or {}) do
        lines[#lines + 1] = string.format(
          "  %s: %s · resets %s",
          tostring(window.label or "limit"),
          percent(window.usedPercent),
          resetTime(window.resetsAt)
        )
      end
      tooltip[#tooltip + 1] = table.concat(lines, "\n")
    end
  end
  barWidget.render(ui.row({ align = "center", gap = 7 }, segments))
  barWidget.setTooltip(table.concat(tooltip, "\n\n"))
end

local function refresh(force)
  if refreshing then
    return
  end
  refreshing = true
  render()
  local command = '"$HOME/.local/bin/mise" exec -- "$HOME/.local/bin/ai-usage"'
  if force then
    command = command .. " --refresh"
  end
  local started = noctalia.runAsync(command, function(result)
    refreshing = false
    if result == nil or result.exitCode ~= 0 then
      snapshot = nil
      render()
      return
    end
    local ok, decoded = pcall(noctalia.json.decode, result.stdout)
    if ok and type(decoded) == "table" then
      snapshot = decoded
    else
      snapshot = nil
    end
    render()
  end)
  if not started then
    refreshing = false
    snapshot = nil
    render()
  end
end

function update()
  noctalia.setUpdateInterval(REFRESH_INTERVAL_MS)
  refresh(false)
end

function onClick()
  refresh(true)
end

noctalia.setUpdateInterval(REFRESH_INTERVAL_MS)
refresh(false)
