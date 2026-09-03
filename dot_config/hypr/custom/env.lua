-- Japanese input: Fcitx5 + Mozc on a US keyboard layout
for name, value in pairs({
    XCURSOR_SIZE = "24",
    HYPRCURSOR_SIZE = "24",
    QT_IM_MODULE = "fcitx",
    XMODIFIERS = "@im=fcitx",
    SDL_IM_MODULE = "fcitx",
}) do
    hl.env(name, value)
end
