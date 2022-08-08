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
		require('lsp_signature').on_attach()
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
