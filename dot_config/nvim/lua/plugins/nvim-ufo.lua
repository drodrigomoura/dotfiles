return {
  -- {
  --   "luukvbaal/statuscol.nvim",
  --   config = function()
  --     local builtin = require("statuscol.builtin")
  --     require("statuscol").setup({
  --       segments = {
  --         { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
  --         { text = { " %s" }, click = "v:lua.ScSa" },
  --         { text = { builtin.lnumfunc, " " }, condition = { true, builtin.not_empty }, click = "v:lua.ScLa" },
  --       },
  --     })
  --   end,
  -- },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "neovim/nvim-lspconfig" },
    --stylua: ignore
    keys = { 
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds", },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds", },
    },
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      require("ufo").setup(opts)
    end,
  },
}
