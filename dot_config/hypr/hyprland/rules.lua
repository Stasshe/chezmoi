require("hyprland.variables")

-- ######## Window rules ########

-- Disable blur for xwayland context menus
hl.window_rule({match = {class = "^()$", title = "^()$" },                   no_blur = true })

-- Disable blur for every window
hl.window_rule({match = {class = ".*" }, no_blur = true })

-- Floating
hl.window_rule({match = {title = "^(Open File)(.*)$" },                      center = true})
hl.window_rule({match = {title = "^(Open File)(.*)$" },                      float = true})
hl.window_rule({match = {title = "^(Select a File)(.*)$" },                  center = true})
hl.window_rule({match = {title = "^(Select a File)(.*)$" },                  float = true})
hl.window_rule({match = {title = "^(Choose wallpaper)(.*)$" },               center = true})
hl.window_rule({match = {title = "^(Choose wallpaper)(.*)$" },               float = true})
hl.window_rule({match = {title = "^(Choose wallpaper)(.*)$" },               size = {"(monitor_w*0.60)", "(monitor_h*0.65)"} })
hl.window_rule({match = {title = "^(Open Folder)(.*)$" },                    center = true})
hl.window_rule({match = {title = "^(Open Folder)(.*)$" },                    float = true})
hl.window_rule({match = {title = "^(Save As)(.*)$" },                        center = true})
hl.window_rule({match = {title = "^(Save As)(.*)$" },                        float = true})
hl.window_rule({match = {title = "^(Library)(.*)$" },                        center = true})
hl.window_rule({match = {title = "^(Library)(.*)$" },                        float = true})
hl.window_rule({match = {title = "^(File Upload)(.*)$" },                    center = true})
hl.window_rule({match = {title = "^(File Upload)(.*)$" },                    float = true})
hl.window_rule({match = {title = "^(.*)(wants to save)$" },                  center = true})
hl.window_rule({match = {title = "^(.*)(wants to save)$" },                  float = true})
hl.window_rule({match = {title = "^(.*)(wants to open)$" },                  center = true})
hl.window_rule({match = {title = "^(.*)(wants to open)$" },                  float = true})
hl.window_rule({match = {class = "^(blueberry\\.py)$" },                     float = true})
hl.window_rule({match = {class = "^(guifetch)$" },                           float = true}) -- FlafyDev/guifetch
hl.window_rule({match = {class = "^(pavucontrol)$" },                        float = true})
hl.window_rule({match = {class = "^(pavucontrol)$" },                        size = {"(monitor_w*0.45)", "(monitor_h*0.45)"} })
hl.window_rule({match = {class = "^(pavucontrol)$" },                        center = true})
hl.window_rule({match = {class = "^(org.pulseaudio.pavucontrol)$" },         float = true})
hl.window_rule({match = {class = "^(org.pulseaudio.pavucontrol)$" },         size = {"(monitor_w*0.45)", "(monitor_h*0.45)"} })
hl.window_rule({match = {class = "^(org.pulseaudio.pavucontrol)$" },         center = true})
hl.window_rule({match = {class = "^(nm-connection-editor)$" },               float = true})
hl.window_rule({match = {class = "^(nm-connection-editor)$" },               size = {"(monitor_w*0.45)", "(monitor_h*0.45)"} })
hl.window_rule({match = {class = "^(nm-connection-editor)$" },               center = true})
hl.window_rule({match = {title = ".*Welcome" },                              float = true})
hl.window_rule({match = {title = ".*Shell conflicts.*" },                    float = true})
hl.window_rule({match = {class = "^(Zotero)$" },                             float = true})
hl.window_rule({match = {class = "^(Zotero)$" },                             size = {"(monitor_w*0.45)", "(monitor_h*0.45)"} })

hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})

-- Tiling
hl.window_rule({match = {class = "^dev\\.warp\\.Warp$" }, tile = true})

-- Picture-in-Picture
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true})
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, keep_aspect_ratio = true})
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, move = {"(monitor_w*0.73)", "(monitor_h*0.72)"} })
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, size = {"(monitor_w*0.25)", "(monitor_h*0.25)"} })
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true})
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, pin = true})

-- Screen sharing
hl.window_rule({match = {title = ".*is sharing (a window|your screen).*" }, float = true})
hl.window_rule({match = {title = ".*is sharing (a window|your screen).*" }, pin = true})
hl.window_rule({match = {title = ".*is sharing (a window|your screen).*" }, move = {"(monitor_w*.5-window_w*.5)", "(monitor_h-window_h-12)"} })

-- --- Tearing ---
hl.window_rule({match = {title = ".*\\.exe" }, immediate = true})
hl.window_rule({match = {title = ".*minecraft.*" }, immediate = true})
hl.window_rule({match = {class = "^(steam_app).*" }, immediate = true})

-- No shadow for tiled windows
hl.window_rule({match = {float = 0 }, no_shadow = true})

-- ######## Workspace rules ########
local workspaceRules = {}
local configHome = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"

local function readWorkspaceMonitorOrder()
    local path = configHome .. "/hypr/custom/workspace-order.conf"
    local file = assert(io.open(path, "r"))
    local order = {}

    for line in file:lines() do
        if line ~= "" then
            local identityType, identity = line:match("^([^\t]+)\t([^\t]+)")
            if (identityType ~= "serial" and identityType ~= "name") or not identity then
                file:close()
                error("Invalid workspace monitor order: " .. line)
            end
            order[#order + 1] = {
                identityType = identityType,
                identity = identity,
            }
        end
    end

    file:close()
    return order
end

local function getOrderedMonitors()
    local orderByName = {}
    local monitors = hl.get_monitors()

    for index, identity in ipairs(readWorkspaceMonitorOrder()) do
        for _, monitor in ipairs(monitors) do
            local matchesSerial = identity.identityType == "serial" and monitor.serial == identity.identity
            local matchesName = identity.identityType == "name" and monitor.name == identity.identity
            if matchesSerial or matchesName then
                orderByName[monitor.name] = index
                break
            end
        end
    end

    table.sort(monitors, function(left, right)
        local leftOrder = orderByName[left.name]
        local rightOrder = orderByName[right.name]

        if leftOrder and rightOrder then
            return leftOrder < rightOrder
        end
        if leftOrder then
            return true
        end
        if rightOrder then
            return false
        end
        if left.x ~= right.x then
            return left.x < right.x
        end
        if left.y ~= right.y then
            return left.y < right.y
        end

        return left.name < right.name
    end)

    return monitors
end

local function moveExistingWorkspaces(monitors)
    for _, workspace in ipairs(hl.get_workspaces()) do
        if not workspace.special and workspace.id > 0 then
            local monitorIndex = math.floor((workspace.id - 1) / workspaceGroupSize) + 1
            local monitor = monitors[monitorIndex]

            if monitor and (not workspace.monitor or workspace.monitor.name ~= monitor.name) then
                hl.dispatch(hl.dsp.workspace.move({
                    workspace = workspace,
                    monitor = monitor,
                }))
            end
        end
    end
end

local function updateWorkspaceRules()
    for _, rule in ipairs(workspaceRules) do
        rule:set_enabled(false)
    end

    workspaceRules = {}
    local monitors = getOrderedMonitors()

    for monitorIndex, monitor in ipairs(monitors) do
        local firstWorkspace = (monitorIndex - 1) * workspaceGroupSize + 1
        local lastWorkspace = monitorIndex * workspaceGroupSize

        for workspace = firstWorkspace, lastWorkspace do
            workspaceRules[#workspaceRules + 1] = hl.workspace_rule({
                workspace = tostring(workspace),
                monitor = monitor.name,
                persistent = true,
            })
        end
    end

    moveExistingWorkspaces(monitors)
end

local function removeExcessWorkspaces()
    local lastWorkspace = #hl.get_monitors() * workspaceGroupSize
    local activeWorkspace = hl.get_active_workspace()

    if lastWorkspace == 0 then
        return
    end

    for _, window in ipairs(hl.get_windows()) do
        if window.workspace and window.workspace.id > lastWorkspace then
            local targetWorkspace = (window.workspace.id - 1) % workspaceGroupSize + 1
            hl.dispatch(hl.dsp.window.move({
                workspace = tostring(targetWorkspace),
                window = window,
                follow = false,
            }))
        end
    end

    if activeWorkspace and activeWorkspace.id > lastWorkspace then
        local targetWorkspace = (activeWorkspace.id - 1) % workspaceGroupSize + 1
        hl.dispatch(hl.dsp.focus({ workspace = tostring(targetWorkspace) }))
    end
end

updateWorkspaceRules()
hl.on("monitor.added", updateWorkspaceRules)
hl.on("monitor.removed", function()
    removeExcessWorkspaces()
    updateWorkspaceRules()
end)

hl.workspace_rule({ workspace = "special:special", gaps_out = 30 })

-- ######## Layer rules ########
hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})
