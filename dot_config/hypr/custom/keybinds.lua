hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

local launcher = "noctalia msg panel-toggle launcher"

hl.bind(
    "Zenkaku_Hankaku",
    hl.dsp.exec_cmd("fcitx5-remote -t"),
    { description = "Input: Toggle Japanese" }
)

hl.unbind("SUPER + SUPER_L")
hl.unbind("SUPER + SUPER_R")
hl.bind("SUPER + R", hl.dsp.exec_cmd(launcher), { description = "Shell: Toggle launcher" })
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(launcher), { description = "Shell: Toggle launcher" })
hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd(launcher))

local navigation_keys = {
    { key = "H", direction = "l", workspace_offset = -1, move_workspace = "r-1" },
    { key = "J", direction = "d", workspace_offset = 5 },
    { key = "K", direction = "u", workspace_offset = -5 },
    { key = "L", direction = "r", workspace_offset = 1, move_workspace = "r+1" },
}

local function focus_workspace_by_offset(offset)
    local current = hl.get_active_workspace().id
    local target = (current - 1 + offset) % workspaceGroupSize + 1
    hl.dispatch(hl.dsp.focus({ workspace = tostring(target) }))
end

for _, binding in ipairs(navigation_keys) do
    hl.unbind("SUPER + " .. binding.key)
    hl.bind("SUPER + " .. binding.key, hl.dsp.focus({ direction = binding.direction }))
    hl.bind("CTRL + SUPER + " .. binding.key, function()
        focus_workspace_by_offset(binding.workspace_offset)
    end)

    if binding.move_workspace then
        hl.bind(
            "SUPER + ALT + " .. binding.key,
            hl.dsp.window.move({ workspace = binding.move_workspace })
        )
    end
end
