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


		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		vim.opt.softtabstop = 4

		local use_spaces = {
			javascript = true,
			typescript = true,
			javascriptreact = true,
			typescriptreact = true,
			python = true,
			yaml = true,
		}

		local ft = vim.bo[args.buf].filetype
		vim.opt.expandtab = false
		if use_spaces[ft] then
			vim.opt_local.expandtab = true
		end
	end
})

-- disable <F1> help menu
vim.keymap.set('n', '<F1>', '<nop>')
vim.keymap.set('i', '<F1>', '<nop>')

-- highlight trailing spaces
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

set_read_only(os.getenv("HOME") .. '/.rustup/*')
set_read_only(os.getenv("HOME") .. '/.cargo/*')

-- necessary when going to definition of a cgo stuff.
set_read_only(os.getenv("HOME") .. '/.cache/go-build/*')

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

-- Workaround for https://github.com/neovim/neovim/issues/35110
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
	callback = function(args)
		local bufnr = args.buf
		if vim.lsp.inlay_hint.is_enabled({bufnr = bufnr}) then
			vim.lsp.inlay_hint.enable(false, {bufnr = bufnr})
			vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
		end
	end,
})
