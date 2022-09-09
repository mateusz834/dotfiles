local set = vim.keymap.set

set('n', '<C-e>', ':WinResizerStartResize<Enter>')

set('n', '<leader>ff', ':Telescope find_files<Enter>')
set('n', '<leader>fg', ':Telescope live_grep<Enter>')
set('n', '<leader>fb', ':Telescope buffers<Enter>')

set('n', '<leader>tn', ':tabnew<Enter>')
set('n', '<leader>fe', ':Ex<Enter>')
set('n', '<leader>h', ':noh<Enter>')

--move current line up/down
set('n', '<c-J>', ':m +1<Enter>')
set('n', 'ə', ':m +1<Enter>') -- Right Alt + j
set('n', '<c-K>', ':m -2<Enter>')
set('n', '…', ':m -2<Enter>') -- Right Alt + k

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

local M = {}
M.go_on_attach = function(client, bufnr)
	local bufopts = { noremap=true, silent=true, buffer=bufnr }

	set('n', 'gd', vim.lsp.buf.definition, bufopts)
	set('n', 'K', vim.lsp.buf.hover, bufopts)
	set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	set('n', '<C-space>', vim.lsp.buf.signature_help, bufopts)
	set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	set('n', 'gr', vim.lsp.buf.references, bufopts)
	set('n', '<space>f', function() require('go.format').goimport() end, bufopts)
	set('n', '<space>cl', ':GoCodeLenAct<Enter>', bufopts)
	set('n', '<space>gc', function()
		vim.lsp.buf.execute_command({
			command = 'gopls.toggle_gc_details', 
			arguments = { { URI = vim.uri_from_bufnr(0) } }
		})
		--[[
		local view = vim.fn.winsaveview()
		vim.cmd(":0")
		vim.cmd(":keeppatterns /^package ")
		vim.cmd(":GoCodeLenAct")
		vim.fn.winrestview(view)
		]]--
	end, bufopts)
end

return M

