return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = {
          selection = { preselect = true, auto_insert = false },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
    },
  },
}
