vim.cmd 'colorscheme nightfox'
require('plugins')
require("config.telescope")
require("config.whichkey")
require("config.formatter")
require("config.lsp_config")
require("config.lualine")
require("config.treesitter")
require("config.rb_highlight")
require("config.gitsigns")
vim.o.hidden = true
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.colorcolumn = "120"
