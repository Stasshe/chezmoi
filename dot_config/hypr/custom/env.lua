for name, value in pairs({
    XCURSOR_SIZE = "24",
    HYPRCURSOR_SIZE = "24",

    -- Japanese input: Fcitx5 + Mozc
    QT_IM_MODULE = "fcitx",
    XMODIFIERS = "@im=fcitx",
    SDL_IM_MODULE = "fcitx",

    -- Java Swing apps (Ghidra) render blank on non-reparenting WMs
    _JAVA_AWT_WM_NONREPARENTING = "1",
}) do
    hl.env(name, value)
end
