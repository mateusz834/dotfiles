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

-- akinsho/toggleterm.nvim
require("toggleterm").setup({
	open_mapping = [[<c-\>]],
})
function _G.set_terminal_keymaps()
	local opts = {buffer = 0}
	vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- nvim-treesitter/nvim-treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = { 'go', 'lua', 'rust' },
	highlight = {
		enable = true,
		disable = function(lang, bufnr)
			if lang == "go" and vim.api.nvim_buf_line_count(bufnr) > 1000 then
				return true
			end
		end
	},
})
