-- This file sources other files in `hyprland` and `custom` folders
-- You wanna add your stuff in files in `custom`

local config_home = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"

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

local state_home = os.getenv("XDG_STATE_HOME") or os.getenv("HOME") .. "/.local/state"
local keyboard_layout_file = io.open(state_home .. "/keyboard-layout", "r")
if keyboard_layout_file then
    local layouts = { us = "us", jis = "jp" }
    local keyboard_layout = layouts[keyboard_layout_file:read("*l")]
    keyboard_layout_file:close()
    if keyboard_layout then
        hl.config({ input = { kb_layout = keyboard_layout } })
    end
end

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
