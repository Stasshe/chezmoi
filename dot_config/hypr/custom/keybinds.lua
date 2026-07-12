hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

-- Windows-Snap-style half-screen layout for floating windows.
-- SUPER + Left/Right/Up/Down are already "focus direction" and
-- SUPER + SHIFT + Left/Right/Up/Down are already "move in direction" (tiled),
-- so this uses SUPER + ALT + arrows, which was free.
-- Hyprland 0.55's `hyprctl dispatch` takes a Lua expression, not the old
-- positional-args string, so the math lives in a script instead.
local snapDirs = { Left = "left", Right = "right", Up = "top", Down = "bottom" }
for key, dir in pairs(snapDirs) do
    hl.bind("SUPER + ALT + " .. key, hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/snap.sh " .. dir),
        { description = "Window: Snap " .. key })
end
