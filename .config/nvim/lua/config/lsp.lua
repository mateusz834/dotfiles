function global_on_attach(bufnr)
	require('lsp_signature').on_attach({},bufnr)
end

-- Javascript/Typescript
require('lspconfig').tsserver.setup({
	cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/typescript-language-server", "--stdio"},
    on_attach = function(client, bufnr)
		require('config.keymap').js_on_attach(client, bufnr)
		global_on_attach()
    end,
})
require'lspconfig'.eslint.setup({
	cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/vscode-eslint-language-server", "--stdio"},
    on_attach = function(client, bufnr)
		require('config.keymap').js_on_attach(client, bufnr)
		global_on_attach()
    end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = {'*.js'},
	callback = function()
		 vim.lsp.buf.format({async=false})
	end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = {'*.jsx'},
	callback = function()
		 vim.lsp.buf.format({async=false})
	end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = {'*.ts'},
	callback = function()
		 vim.lsp.buf.format({async=false})
	end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = {'*.tsx'},
	callback = function()
		 vim.lsp.buf.format({async=false})
	end,
})

-- For HTML and CSS.
-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- HTML
require('lspconfig').html.setup({
	capabilities = capabilities,
	cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/vscode-html-language-server", "--stdio"},
    on_attach = function(client, bufnr)
		require('config.keymap').html_on_attach(client, bufnr)
		global_on_attach()
    end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = {'*.html'},
	callback = function()
		 vim.lsp.buf.format({async=false})
	end,
})

-- CSS
require('lspconfig').cssls.setup({
	capabilities = capabilities,
	cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/vscode-css-language-server", "--stdio"},
    on_attach = function(client, bufnr)
		require('config.keymap').css_on_attach(client, bufnr)
		global_on_attach()
    end,
})

-- Zig
require('lspconfig').zls.setup({
    on_attach = function(client, bufnr)
		require('config.keymap').zig_on_attach(client, bufnr)
		global_on_attach()
    end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = {'*.zig'},
	callback = function()
		vim.lsp.buf.format({async=false})
		vim.defer_fn(function()
			-- For some reason zls started to open the Location List, close it.
			vim.cmd.lclose()
		end, 0)
	end,
})

-- Rust
require("rust-tools").setup({
  server = {
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
			},
			enableEnhancedTyping = false,
		},
	},
	cmd = { "rustup", "run", "stable", "rust-analyzer" },
    on_attach = function(client, bufnr)
		require('config.keymap').rust_on_attach(client, bufnr)
		global_on_attach()
    end,
  },
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = {'*.rs'},
	callback = function()
		 vim.lsp.buf.format({async=false})
	end,
})

-- Go
local golspcfg = {
	settings = {
		gopls = {
			analyses = {
				fieldalignment = true,
				unusedwrite = true,
				nilness = true,
				useany = true,
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
			usePlaceholders = false,
		},
	},
}

require('go').setup({
	gofmt="gofmt",
	lsp_cfg = golspcfg,
	lsp_codelens = false,
	lsp_inlay_hints = {
		enable = true,
		parameter_hints_prefix = "▶ ",
		other_hints_prefix = "▬▶",
	},
	lsp_on_client_start = function (client, bufnr)
		require('config.keymap').go_on_attach(client, bufnr)
		global_on_attach()
	end,
	lsp_keymaps = false,
	gopls_cmd = { 'gopls',  '-remote.listen.timeout=15s'},
	lsp_diag_virtual_text = { prefix = "●" },
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = {'*.go'},
	callback = function()
		require('go.format').goimport()
	end,
})


--[[
require('lspconfig').golangci_lint_ls.setup{
	init_options = {
		--command = { "golangci-lint", "run", "--enable-all", "--disable", "exhaustivestruct,exhaustruct,wsl,gofumpt", "--out-format", "json" };
		--command = { "golangci-lint", "run", "--out-format", "json" };
	}
}
]]--

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
 }
