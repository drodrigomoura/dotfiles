return {
  "ellisonleao/glow.nvim",
  config = true,
  cmd = "Glow",
  opts = {
    -- glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
    -- install_path = "~/.local/bin", -- default path for installing glow binary
    border = "rounded", -- floating window border config
    style = "dark", -- filled automatically with your current editor background, you can override using glow json style
    pager = false,
    width = 180,
    height = 100,
    width_ratio = 0.8, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
    height_ratio = 0.8,
  },
}
