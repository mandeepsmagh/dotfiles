-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.scrollback_lines = 50000

-- Set the default shell for Windows
config.default_prog = {"pwsh", "-NoLogo"}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'
-- Set the font and font size
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 11.0

-- Set the leader key
config.leader = { key="a", mods="CTRL" }

-- Keybindings
config.keys = {
  {key="a", mods="LEADER|CTRL", action=wezterm.action{SendString="\x01"}},
  {key="v", mods="CTRL", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
  {key="h", mods="CTRL", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
  {key="l", mods="SUPER", action="ShowLauncher"},
  {key="r", mods="SUPER", action="ReloadConfiguration"},
  {key="f", mods="LEADER", action="ToggleFullScreen"},
  {key="LeftArrow", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
  {key="RightArrow", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
  {key="UpArrow", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
  {key="DownArrow", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
  {key="LeftArrow", mods="CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 1}}},
  {key="RightArrow", mods="CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 1}}},
  {key="UpArrow", mods="CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 1}}},
  {key="DownArrow", mods="CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 1}}},
  {key="x", mods="CTRL", action=wezterm.action{CloseCurrentPane={confirm=true}}},
  {key="z", mods="CTRL", action="TogglePaneZoomState"},
}
-- and finally, return the configuration to wezterm
return config
