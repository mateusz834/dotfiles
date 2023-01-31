local set = vim.opt
local cmd = vim.cmd
local g = vim.g

set.number=true
set.scrolloff=3
set.relativenumber=true

set.ignorecase=true
--set.wrapscan=false

set.clipboard=unnamedplus

set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.smartindent = true
--set.expandtab = true --replace tab with spaces
--
-- disable <F1> help menu
vim.keymap.set('n', '<F1>', '<nop>')
vim.keymap.set('i', '<F1>', '<nop>')

-- higlight trailing spaces
cmd('highlight ExtraWhitespace ctermbg=green guibg=green')
cmd('match ExtraWhitespace /\\s\\+$/')

g.mapleader=' '

-- folke/tokyonight.nvim
cmd('colorscheme tokyonight-night')

-- simeji/winresizer
g.winresizer_vert_resize=2
g.winresizer_horiz_resize=2
g.winresizer_start_key='' --binding removed here so, that i have it explicit in kaymap fils

-- folke/todo-comments.nvim
require("todo-comments").setup({
	highlight = {
		before = "fg",
		keyword = "fg",
		pattern = [[.*<(KEYWORDS)\s*]],
	},
	search = {
		pattern = [[\b(KEYWORDS)\b]],
	},
})

-- folke/trouble.nvim
require("trouble").setup({})

-- nvim-treesitter/nvim-treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = { 'go', 'lua', 'rust', 'zig'},
	highlight = {
		enable = true,
		disable = function(lang, bufnr)
			if lang == "go" and vim.api.nvim_buf_line_count(bufnr) > 1000 then
				return true
			end
		end
	},
})

-- make /home/mateusz/.rustup directory read-only.
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
	pattern = '/home/mateusz/.rustup/*',
	callback = function()
		vim.bo.readonly = true
	end,
})

-- make /home/mateusz/.cargo directory read-only.
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
	pattern = '/home/mateusz/.cargo/*',
	callback = function()
		vim.bo.readonly = true
	end,
})

-- make /home/mateusz/.cache/go-build directory read-only.
-- necessary when going to definition of a cgo stuff.
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
	pattern = '/home/mateusz/.cache/go-build/*',
	callback = function()
		vim.bo.readonly = true
	end,
})
