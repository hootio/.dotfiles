-- meta.nvim: only loaded on devserver
if not vim.g.is_devserver then
  return {}
end

return {
  {
    dir = "/usr/share/fb-editor-support/nvim",
    name = "meta.nvim",
    config = function()
      -- Meta LSP servers
      require("meta.lsp")
      vim.lsp.enable()

      -- Mercurial integration (replaces gitsigns on devserver)
      require("meta.hg").setup()

      -- Meta keymaps
      require("meta.keymaps")

      -- Metamate AI assistant
      require("meta.metamate").init()
    end,
  },
}
