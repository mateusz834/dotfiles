local set = vim.opt
local cmd = vim.cmd
local g = vim.g

set.number=true
set.scrolloff=3
set.relativenumber=true

-- use fsync when saving files.
-- to preserve files after system crash.
set.fsync = true;

set.ignorecase=true
--set.wrapscan=false

set.clipboard=unnamedplus

vim.api.nvim_create_autocmd('FileType', {
	pattern = { "*" },
	callback = function(args)
		set.smartindent = true

		local ft = vim.bo[args.buf].filetype
		if ft == "javascript" or ft == "typescript" then
			set.tabstop = 2
			set.shiftwidth = 2
			set.softtabstop = 2
			set.expandtab = true --replace tab with spaces
		else
			set.tabstop = 4
			set.shiftwidth = 4
			set.softtabstop = 4
			set.expandtab = false --replace tab with spaces
		end
	end
})

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
	ensure_installed = { 'go', 'lua', 'rust', 'zig', 'html', 'css', 'javascript', 'typescript', 'jsdoc', 'svelte', 'tsx', 'python', 'sql' },
	highlight = {
		enable = true,
		disable = function(lang, bufnr)
			if lang == "go" and vim.api.nvim_buf_line_count(bufnr) > 1000 then
				return true
			end
		end
	},
})

function set_read_only(dir)
	vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
		pattern = dir,
		callback = function()
			vim.bo.readonly = true
		end,
	})
end

set_read_only('/home/mateusz/.rustup/*')
set_read_only('/home/mateusz/.cargo/*')

-- necessary when going to definition of a cgo stuff.
set_read_only('/home/mateusz/.cache/go-build/*')

-- Make the hover preview (under 'K' keymap) with a max width and a rounded border.
-- Source: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.max_width = opts.max_width or 120
	opts.border = opts.border or "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require('telescope').setup{ defaults = { file_ignore_patterns = {"node_modules"} } }
