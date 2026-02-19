local opt = vim.opt

-- Devserver detection
vim.g.is_devserver = vim.fn.isdirectory("/usr/share/fb-editor-support/nvim") == 1

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Relative number toggle: absolute in insert mode, relative in normal
local number_group = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = number_group,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = number_group,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"

-- UI
opt.cursorline = true
opt.signcolumn = "yes"
opt.showmode = false
opt.laststatus = 3
opt.scrolloff = 4
opt.wrap = false
opt.termguicolors = true
opt.pumheight = 10
opt.conceallevel = 2

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Editing
opt.mouse = "a"
opt.undofile = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.autowrite = true
opt.clipboard = "unnamedplus"
opt.hidden = true
opt.joinspaces = false
opt.completeopt = "menu,menuone,noselect"
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Wildmenu
opt.wildmode = "full"

-- Fill chars
opt.fillchars = { eob = " ", diff = "╱" }

-- OSC 52 clipboard support for remote SSH sessions
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
