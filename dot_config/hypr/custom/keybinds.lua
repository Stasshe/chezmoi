hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

local launcher = "noctalia msg panel-toggle launcher"

hl.unbind("SUPER + SUPER_L")
hl.unbind("SUPER + SUPER_R")
hl.bind("SUPER + R", hl.dsp.exec_cmd(launcher), { description = "Shell: Toggle launcher" })
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(launcher), { description = "Shell: Toggle launcher" })
hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd(launcher))

local navigation_keys = {
    { key = "H", arrow = "Left", direction = "l", workspace = "-1", workspace_offset = -1 },
    { key = "J", arrow = "Down", direction = "d", workspace = "+5", workspace_offset = 5 },
    { key = "K", arrow = "Up", direction = "u", workspace = "-5", workspace_offset = -5 },
    { key = "L", arrow = "Right", direction = "r", workspace = "+1", workspace_offset = 1 },
}

local window_move_keys = {
    { key = "U", direction = "l" },
    { key = "I", direction = "d" },
    { key = "O", direction = "u" },
    { key = "P", direction = "r" },
}

local arrow_keys = {
    { key = "H", arrow = "Left" },
    { key = "J", arrow = "Down" },
    { key = "K", arrow = "Up" },
    { key = "L", arrow = "Right" },
}

local function move_window_to_workspace(offset)
    local currentWorkspace = hl.get_active_workspace().id
    local targetWorkspace = currentWorkspace + offset
    local lastWorkspace = #hl.get_monitors() * workspaceGroupSize

    if targetWorkspace < 1 or targetWorkspace > lastWorkspace then
        return
    end

    hl.dispatch(hl.dsp.window.move({ workspace = tostring(targetWorkspace) }))
end

for _, binding in ipairs(navigation_keys) do
    hl.unbind("SUPER + " .. binding.key)
    hl.bind("SUPER + " .. binding.key, hl.dsp.focus({ direction = binding.direction }))

    for _, key in ipairs({ binding.key, binding.arrow }) do
        hl.unbind("CTRL + SUPER + " .. key)
        hl.bind("CTRL + SUPER + " .. key, hl.dsp.focus({ workspace = binding.workspace }))
    end

    hl.bind(
        "SUPER + ALT + " .. binding.key,
        function()
            move_window_to_workspace(binding.workspace_offset)
        end
    )
end

for _, binding in ipairs(window_move_keys) do
    hl.unbind("SUPER + SHIFT + " .. binding.key)
    hl.bind(
        "SUPER + SHIFT + " .. binding.key,
        hl.dsp.window.move({ direction = binding.direction }),
        { description = "Window: Move " .. binding.direction }
    )
end

for _, binding in ipairs(arrow_keys) do
    hl.bind(
        "ALT + " .. binding.key,
        hl.dsp.send_shortcut({ mods = "", key = binding.arrow }),
        { repeating = true, description = "Input: " .. binding.arrow }
    )
end
