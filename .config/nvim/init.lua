-- Set leader keys before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load options first (includes devserver detection)
require("config.options")

-- Bootstrap and configure lazy.nvim
require("config.lazy")

-- Keymaps and autocmds are loaded after plugins via lazy VeryLazy event
