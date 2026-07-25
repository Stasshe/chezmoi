hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

local launcher = "noctalia msg panel-toggle launcher"

hl.unbind("SUPER + SUPER_L")
hl.unbind("SUPER + SUPER_R")
hl.bind("SUPER + R", hl.dsp.exec_cmd(launcher), { description = "Shell: Toggle launcher" })
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(launcher), { description = "Shell: Toggle launcher" })
hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd(launcher))

local focus_keys = {
    H = "l",
    J = "d",
    K = "u",
    L = "r",
}

for key, direction in pairs(focus_keys) do
    hl.unbind("SUPER + " .. key)
    hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }))
end
