return {
  -- Treesitter (parser installation and highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "TSInstall", "TSUpdate", "TSUpdateSync" },
    config = function()
      -- Treesitter highlighting and indent are built into Neovim.
      -- This plugin handles parser installation and management.
      -- Install parsers with :TSInstall <language>
      -- Core parsers to install: bash, c, diff, html, javascript, json, lua,
      --   luadoc, markdown, markdown_inline, python, query, regex, toml, tsx,
      --   typescript, vim, vimdoc, xml, yaml
    end,
  },

  -- Textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local ts_select = require("nvim-treesitter-textobjects.select")
      local ts_move = require("nvim-treesitter-textobjects.move")
      local ts_swap = require("nvim-treesitter-textobjects.swap")

      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      -- Select textobjects
      local select_map = function(key, query)
        vim.keymap.set({ "x", "o" }, key, function()
          ts_select.select_textobject(query)
        end, { desc = "Select " .. query })
      end
      select_map("af", "@function.outer")
      select_map("if", "@function.inner")
      select_map("ac", "@class.outer")
      select_map("ic", "@class.inner")
      select_map("aa", "@parameter.outer")
      select_map("ia", "@parameter.inner")

      -- Move to next/prev textobjects
      local move_map = function(key, fn, query, desc)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          fn(query)
        end, { desc = desc })
      end
      move_map("]f", ts_move.goto_next_start, "@function.outer", "Next Function Start")
      move_map("]c", ts_move.goto_next_start, "@class.outer", "Next Class Start")
      move_map("]a", ts_move.goto_next_start, "@parameter.inner", "Next Parameter")
      move_map("]F", ts_move.goto_next_end, "@function.outer", "Next Function End")
      move_map("]C", ts_move.goto_next_end, "@class.outer", "Next Class End")
      move_map("[f", ts_move.goto_previous_start, "@function.outer", "Prev Function Start")
      move_map("[c", ts_move.goto_previous_start, "@class.outer", "Prev Class Start")
      move_map("[a", ts_move.goto_previous_start, "@parameter.inner", "Prev Parameter")
      move_map("[F", ts_move.goto_previous_end, "@function.outer", "Prev Function End")
      move_map("[C", ts_move.goto_previous_end, "@class.outer", "Prev Class End")

      -- Swap parameters
      vim.keymap.set("n", "<leader>a", function()
        ts_swap.swap_next("@parameter.inner")
      end, { desc = "Swap Next Parameter" })
      vim.keymap.set("n", "<leader>A", function()
        ts_swap.swap_previous("@parameter.inner")
      end, { desc = "Swap Prev Parameter" })
    end,
  },
}
