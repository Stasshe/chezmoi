-- put former exec-once commands inside the func and former exec commands outside
hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
end)
