local map = vim.keymap.set

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Clear search highlight with <Esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Diagnostic navigation
map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Next Diagnostic" })
map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "Prev Diagnostic" })
map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next Error" })
map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error" })
map("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, { desc = "Next Warning" })
map("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, { desc = "Prev Warning" })

-- Splits
map("n", "<leader>-", "<C-W>s", { desc = "Split Below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split Right" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Buffer delete
map("n", "<leader>bd", function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    vim.ui.select({ "Yes", "No" }, { prompt = "Buffer has unsaved changes. Save?" }, function(choice)
      if choice == "Yes" then
        vim.cmd.write()
        vim.cmd("bdelete " .. buf)
      elseif choice == "No" then
        vim.cmd("bdelete! " .. buf)
      end
    end)
  else
    vim.cmd("bdelete " .. buf)
  end
end, { desc = "Delete Buffer" })

-- Diagnostics
map("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "Location List" })
map("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "Quickfix List" })
