--!nonstrict

local REFRESH_INTERVAL_MS = 300000
local providers = {
  { key = "codex", label = "Codex" },
  { key = "claude", label = "Claude" },
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
  barWidget.setGlyph("chart-bar")
  if refreshing and snapshot == nil then
    barWidget.setText("AI …")
    barWidget.setTooltip("Loading Codex and Claude usage")
    return
  end
  if type(snapshot) ~= "table" then
    barWidget.setText("AI !")
    barWidget.setTooltip("AI usage is unavailable")
    return
  end

  local text = {}
  local tooltip = {}
  for _, spec in ipairs(providers) do
    local provider = snapshot[spec.key] or {}
    text[#text + 1] = spec.label .. " " .. providerText(provider)
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
  barWidget.setText(table.concat(text, " · "))
  barWidget.setTooltip(table.concat(tooltip, "\n\n"))
end

local function refresh()
  if refreshing then
    return
  end
  refreshing = true
  render()
  local started = noctalia.runAsync("ai-usage", function(result)
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
  refresh()
end

function onClick()
  refresh()
end

noctalia.setUpdateInterval(REFRESH_INTERVAL_MS)
refresh()
