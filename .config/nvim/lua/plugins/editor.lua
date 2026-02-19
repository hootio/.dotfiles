return {
  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = require("gitsigns")
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      end,
    },
  },

  -- Auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
    },
  },

  -- Better text objects (around/inside)
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      }
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = vim.g.is_devserver and {} or {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        -- Don't format on save if no formatter is configured
        if vim.tbl_isempty(require("conform").list_formatters(bufnr)) then
          return
        end
        return { timeout_ms = 3000, lsp_fallback = true }
      end,
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
  },
}
