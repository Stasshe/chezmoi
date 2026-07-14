-- Always raise the newly-focused window above overlapping siblings
-- (matters for floating windows, which don't auto-stack like tiled ones).
hl.on("window.active", function()
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
