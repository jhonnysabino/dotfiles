local wezterm = require 'wezterm'
local config = wezterm.config_builder()

--- Config
config.font = wezterm.font_with_fallback({
  'JetBrainsMono Nerd Font Mono',
  'Symbols Nerd Font Mono',
})
config.font_size = 10
config.color_scheme = 'GruvboxDarkHard'
config.scrollback_lines = 1000000

local function is_nvim(pane)
  return pane:get_user_vars().IS_NVIM == 'true'
end

local nav = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }

config.keys = {
  -- Split panes
  { key = '\\', mods = 'CTRL',       action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-',  mods = 'CTRL',       action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Close pane
  { key = 'w',  mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = false } },

  -- Zoom pane
  { key = 'm',  mods = 'CTRL|SHIFT', action = wezterm.action.TogglePaneZoomState },

  -- Navegar abas
  { key = '[',  mods = 'CTRL',       action = wezterm.action.ActivateTabRelative(-1) },
  { key = ']',  mods = 'CTRL',       action = wezterm.action.ActivateTabRelative(1) },

  -- Nova aba
  { key = 't',  mods = 'CTRL',       action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
}

-- Navigate panes: passa a tecla pro neovim se estiver nele, senão navega direto
for key, direction in pairs(nav) do
  table.insert(config.keys, {
    key = key,
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_nvim(pane) then
        win:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction }, pane)
      end
    end),
  })
end

-- Resize panes
for key, direction in pairs(nav) do
  table.insert(config.keys, {
    key = key,
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(win, pane)
      if is_nvim(pane) then
        win:perform_action({ SendKey = { key = key, mods = 'CTRL|SHIFT' } }, pane)
      else
        win:perform_action({ AdjustPaneSize = { direction, 5 } }, pane)
      end
    end),
  })
end

return config
