-- This file sources other files in `hyprland` and `custom` folders
-- You wanna add your stuff in files in `custom`

local config_home = os.getenv("XDG_CONFIG_HOME") or HOME .. "/.config"

-- Internal stuff --
require("hyprland.lib")
require("hyprland.services")

-- Environment variables --
require("hyprland.env")
if is_file_exists(config_home .. "/hypr/custom/env.lua") then
    require("custom.env")
end

-- Default configurations --
require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

-- Custom configurations --
if is_file_exists(config_home .. "/hypr/custom/execs.lua") then
    require("custom.execs")
end
if is_file_exists(config_home .. "/hypr/custom/general.lua") then
    require("custom.general")
end
if is_file_exists(config_home .. "/hypr/custom/rules.lua") then
    require("custom.rules")
end
if is_file_exists(config_home .. "/hypr/custom/keybinds.lua") then
    require("custom.keybinds")
end

-- nwg-displays support --
if is_file_exists(config_home .. "/hypr/workspaces.lua") then
    require("workspaces")
end
if is_file_exists(config_home .. "/hypr/monitors.lua") then
    require("monitors")
end

-- Shell overrides --
require("hyprland.shellOverrides.main")

-- For Noctalia Color templates
require("noctalia").apply_theme()
