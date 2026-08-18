hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

local launcher = "noctalia msg panel-toggle launcher"

hl.unbind("SUPER + SUPER_L")
hl.unbind("SUPER + SUPER_R")
hl.bind("SUPER + R", hl.dsp.exec_cmd(launcher), { description = "Shell: Toggle launcher" })
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(launcher), { description = "Shell: Toggle launcher" })
hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd(launcher))

local navigation_keys = {
    { key = "H", arrow = "Left", direction = "l", workspace = "-1", move_workspace = "r-1" },
    { key = "J", arrow = "Down", direction = "d", workspace = "+5" },
    { key = "K", arrow = "Up", direction = "u", workspace = "-5" },
    { key = "L", arrow = "Right", direction = "r", workspace = "+1", move_workspace = "r+1" },
}

for _, binding in ipairs(navigation_keys) do
    hl.unbind("SUPER + " .. binding.key)
    hl.bind("SUPER + " .. binding.key, hl.dsp.focus({ direction = binding.direction }))

    for _, key in ipairs({ binding.key, binding.arrow }) do
        hl.unbind("CTRL + SUPER + " .. key)
        hl.bind("CTRL + SUPER + " .. key, hl.dsp.focus({ workspace = binding.workspace }))
    end

    if binding.move_workspace then
        hl.bind(
            "SUPER + ALT + " .. binding.key,
            hl.dsp.window.move({ workspace = binding.move_workspace })
        )
    end
end
