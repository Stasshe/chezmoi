hl.config({
    input = {
        kb_layout = "us",
        kb_options = "caps:menu",
    },
    general = {
        border_size = 3,
        col = {
            active_border = "rgba(89b4faff)",
            inactive_border = "rgba(31313600)",
        },
    },
    decoration = {
        -- default true makes the border sit under opaque window content on
        -- straight edges (only the rounded corners expose it) — render it
        -- outside the window bounds instead so the whole border shows.
        border_part_of_window = false,
    },
})

hl.device({
    name = "elan06fa:00-04f3:327e-touchpad",
    sensitivity = 0.2,
})
