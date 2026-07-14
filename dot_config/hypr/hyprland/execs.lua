-- put former exec-once commands inside the func and former exec commands outside
hl.on("hyprland.start", function ()

    -- Bar, wallpaper
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'")
    hl.exec_cmd("qs -c $qsConfig")
    hl.exec_cmd("sleep 5 && $HOME/.config/hypr/custom/scripts/__restore_video_wallpaper.sh")

    -- Core components (lock screen, notification daemon)
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && hypridle")

    -- Audio
    hl.exec_cmd("sleep 5 && easyeffects --hide-window --service-mode")

    -- Clipboard: history
    --hl.exec_cmd("wl-paste --watch cliphist store")
    -- wait until qs IPC is ready before starting watchers
    hl.exec_cmd("until qs -c $qsConfig ipc call cliphistService update >/dev/null 2>&1; do sleep 0.5; done; wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")
    hl.exec_cmd("until qs -c $qsConfig ipc call cliphistService update >/dev/null 2>&1; do sleep 0.5; done; wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")

    -- Cursor
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
end)
