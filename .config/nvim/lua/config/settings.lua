vim.g.mapleader=' '

vim.opt.number=true
vim.opt.scrolloff=3
vim.opt.relativenumber=true

-- use fsync when saving files.
-- to preserve files after system crash.
vim.opt.fsync = true;

vim.opt.ignorecase=true
--set.wrapscan=false

vim.opt.clipboard=unnamedplus

vim.api.nvim_create_autocmd('FileType', {
	pattern = { "*" },
	callback = function(args)
		vim.opt.smartindent = true

		local ft = vim.bo[args.buf].filetype
		if ft == "javascript" or ft == "typescript" then
			vim.opt.tabstop = 2
			vim.opt.shiftwidth = 2
			vim.opt.softtabstop = 2
			vim.opt.expandtab = true --replace tab with spaces
		else
			vim.opt.tabstop = 4
			vim.opt.shiftwidth = 4
			vim.opt.softtabstop = 4
			vim.opt.expandtab = false --replace tab with spaces
		end
	end
})

-- disable <F1> help menu
vim.keymap.set('n', '<F1>', '<nop>')
vim.keymap.set('i', '<F1>', '<nop>')

-- higlight trailing spaces
vim.cmd('highlight ExtraWhitespace ctermbg=green guibg=green')
vim.cmd('match ExtraWhitespace /\\s\\+$/')

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
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

vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim-undotree"
vim.opt.undofile = true

vim.keymap.set("n", "<C-n>", ":cnext<CR>zz")
vim.keymap.set("n", "<C-p>", ":cprev<CR>zz")

-- center when moving
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.diagnostic.config({ virtual_text = true })
