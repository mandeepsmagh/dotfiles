-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()


-- Set the default shell for Windows
config.default_prog = {"pwsh", "-NoLogo"}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'
-- Set the font and font size
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 11.0
-- and finally, return the configuration to wezterm
return config
