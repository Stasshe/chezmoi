-- Nebula desktop: a focused, translucent Hyprland session for Arch Linux.

local mod = "SUPER"

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

for name, value in pairs({
    XCURSOR_SIZE = "24",
    HYPRCURSOR_SIZE = "24",
    GTK_IM_MODULE = "fcitx",
    QT_IM_MODULE = "fcitx",
    XMODIFIERS = "@im=fcitx",
    SDL_IM_MODULE = "fcitx",
}) do
    hl.env(name, value)
end

hl.on("hyprland.start", function()
    hl.exec_cmd("swww-daemon")
    hl.exec_cmd("swww img ~/.local/share/backgrounds/nebula.png --transition-type grow --transition-pos 0.7,0.4")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("fcitx5 -d")
end)

hl.config({
    input = {
        kb_layout = "jp",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
        sensitivity = 0,
    },
    general = {
        gaps_in = 6,
        gaps_out = 18,
        border_size = 1,
        col = {
            active_border = { colors = { "rgba(c4b5fdcc)", "rgba(67e8f9cc)" }, angle = 45 },
            inactive_border = "rgba(ffffff24)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 18,
        active_opacity = 0.96,
        inactive_opacity = 0.82,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            new_optimizations = true,
            xray = true,
            special = true,
        },
        shadow = {
            enabled = true,
            range = 18,
            render_power = 3,
            color = "rgba(080b1a88)",
        },
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        focus_on_activate = true,
    },
})

hl.curve("swift", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("settle", { type = "bezier", points = { { 0.24, 0.72 }, { 0.24, 1 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "swift", style = "popin 88%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "settle", style = "popin 88%" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "settle" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "swift" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "settle", style = "slidevert" })

hl.bind(mod .. " + Q", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind(mod .. " + O", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd([[grim ~/Pictures/Screenshot-"$(date +%F_%H-%M-%S)".png]]))
hl.bind(mod .. " + SHIFT + Return", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mod .. " + apostrophe", hl.dsp.workspace.toggle_special(""))

for _, direction in ipairs({ "l", "r", "u", "d" }) do
    local key = ({ l = "H", r = "L", u = "K", d = "J" })[direction]
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

for workspace = 1, 5 do
    hl.bind(mod .. " + " .. workspace, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. " + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true, size = { 900, 620 }, center = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(ghostty)$" }, opacity = "0.92 0.88" })
