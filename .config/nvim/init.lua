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
require("config.auto-cmp")
vim.o.hidden = true
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.colorcolumn = "120"
vim.g.netrw_liststyle = 3
vim.cmd('let g:netrw_liststyle = 3')
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
