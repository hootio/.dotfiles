-- LSP is disabled on devserver (meta.nvim provides LSP there)
if vim.g.is_devserver then
  return {}
end

return {
  -- nvim-lspconfig provides default configs for vim.lsp.config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- lua_ls config using Neovim 0.11 native API
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            codeLens = { enable = true },
            completion = { callSnippet = "Replace" },
            doc = { privateName = { "^_" } },
            diagnostics = {
              disable = { "missing-fields" },
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")
    end,
  },
}
