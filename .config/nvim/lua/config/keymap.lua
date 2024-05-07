local set = vim.keymap.set

local builtin = require('telescope.builtin')
local utils = require('telescope.utils')
set('n', '<leader>ff', builtin.find_files, {})
set('n', '<leader>fg', builtin.live_grep, {})
set('n', '<leader>df', function() builtin.find_files({ cwd = utils.buffer_dir() }) end)
set('n', '<leader>dg', function() builtin.live_grep({ cwd = utils.buffer_dir() }) end)

set('n', '<leader>fe', ':Ex<Enter>')

set('n', '<leader>ut', ':UndotreeToggle<Enter>')

set("n", "<C-n>", ":cnext<CR>zz")
set("n", "<C-p>", ":cprev<CR>zz")

-- center when moving
set('n', '<c-d>', '<c-d>zz')
set('n', '<c-u>', '<c-u>zz')

-- ThePrimeagen/harpoon
set('n', "<leader>ha", function() require("harpoon.mark").add_file() end, silent)
set('n', "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, silent)
set('n', "ą", function() require("harpoon.ui").nav_file(1) end, silent) -- Right Alt + a
set('n', "ś", function() require("harpoon.ui").nav_file(2) end, silent) -- Right Alt + s
set('n', "ð", function() require("harpoon.ui").nav_file(3) end, silent) -- Right Alt + d
set('n', "æ", function() require("harpoon.ui").nav_file(4) end, silent) -- Right Alt + f

local opts = { noremap=true, silent=true }
set('n', '<space>e', vim.diagnostic.open_float, opts)
set('n', '[d', vim.diagnostic.goto_prev, opts)
set('n', ']d', vim.diagnostic.goto_next, opts)
set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)

function on_lsp_attach(lang, client, bufnr)
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	set('n', 'gd', vim.lsp.buf.definition, bufopts)
	set('n', 'K', vim.lsp.buf.hover, bufopts)
	set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	set('n', '<C-space>', vim.lsp.buf.signature_help, bufopts)
	set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	set('n', 'gr', vim.lsp.buf.references, bufopts)

	if lang == "go" then
		set('n', '<space>f', function() require('go.format').goimport() end, bufopts)
		set('n', '<space>cl', ':GoCodeLenAct<Enter>', bufopts)
		set('n', '<space>gc', function()
			vim.lsp.buf.execute_command({
				command = 'gopls.toggle_gc_details',
				arguments = { { URI = vim.uri_from_bufnr(0) } }
			})
		end, bufopts)
	end
end

return {
	on_attach = on_lsp_attach
}
