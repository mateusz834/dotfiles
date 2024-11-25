local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local isWSL = os.getenv("WSL_DISTRO_NAME") ~= null

require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				on_colors = function(colors)
					colors.comment = '#9c9c9c'
				end,
			})
			vim.cmd('colorscheme tokyonight-night')
			-- lighter line numbers
			vim.cmd('hi LineNr guifg=#9c9c9c')
		end
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {"node_modules"}
				}
			})
			local builtin = require("telescope.builtin")
			local utils = require("telescope.utils")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>df", function() builtin.find_files({ cwd = utils.buffer_dir() }) end)
			vim.keymap.set("n", "<leader>dg", function() builtin.live_grep({ cwd = utils.buffer_dir() }) end)
		end

	},
	{
		'stevearc/oil.nvim',
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
				},
				watch_for_changes = true
			})
			vim.keymap.set("n", "<leader>o", function() require("oil").open() end)
			vim.keymap.set("n", "<leader>O", function() require("oil").open(vim.fn.getcwd()) end)
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = {
					'go',
					'lua',
					'rust',
					'zig',
					'html',
					'css',
					'javascript',
					'typescript',
					'jsdoc',
					'svelte',
					'tsx',
					'python',
					'sql',
				},
				highlight = {
					enable = true,
					disable = function(lang, bufnr)
						--if lang == "go" and vim.api.nvim_buf_line_count(bufnr) > 3000 then
						--	return true
						--end
					end
				},
			})
		end
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
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
		end
	},

	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set('n', "<leader>ha", function() require("harpoon.mark").add_file() end, silent)
			vim.keymap.set('n', "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, silent)
			vim.keymap.set('n', "ą", function() require("harpoon.ui").nav_file(1) end, silent) -- Right Alt + a
			vim.keymap.set('n', "ś", function() require("harpoon.ui").nav_file(2) end, silent) -- Right Alt + s
			vim.keymap.set('n', "ð", function() require("harpoon.ui").nav_file(3) end, silent) -- Right Alt + d
			vim.keymap.set('n', "æ", function() require("harpoon.ui").nav_file(4) end, silent) -- Right Alt + f
		end
	},

	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
		end
	},

	{
		"williamboman/mason.nvim",
		cond = isWSL,
		config = function()
			require("mason").setup()
		end
	},

	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/nvim-cmp',
			'L3MON4D3/LuaSnip',
			'ray-x/lsp_signature.nvim',
			{'Hoffs/omnisharp-extended-lsp.nvim', cond = isWSL},
		},
		config = function()
			function global_on_attach(lang, client, bufnr)
				local bufopts = { noremap=true, silent=true, buffer=bufnr }
				if lang == "c#" then
					vim.keymap.set('n', 'gd', require('omnisharp_extended').lsp_definition, bufopts)
					vim.keymap.set('n', '<space>D', require('omnisharp_extended').lsp_type_definition, bufopts)
					vim.keymap.set('n', 'gr', require('omnisharp_extended').lsp_references, bufopts)
					vim.keymap.set('n', 'gi', require('omnisharp_extended').lsp_implementation, bufopts)
				else
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
					vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
				end
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
				vim.keymap.set('n', '<C-space>', vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
				vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)

				vim.keymap.set({'v', 'n'}, '<space>a', vim.lsp.buf.code_action)

				if lang == "go" then
					vim.keymap.set('n', '<space>f', function() require('go.format').goimport() end, bufopts)
					vim.keymap.set('n', '<space>cl', ':GoCodeLenAct<Enter>', bufopts)
					vim.keymap.set('n', '<space>gc', function()
						vim.lsp.buf.execute_command({
							command = 'gopls.toggle_gc_details',
							arguments = { { URI = vim.uri_from_bufnr(0) } }
						})
					end, bufopts)
				end

				require('lsp_signature').on_attach(client, bufnr)
			end

			if isWSL then
				require('lspconfig').omnisharp.setup {
					cmd = { "omnisharp" },

					settings = {
						FormattingOptions = {
							-- Enables support for reading code style, naming convention and analyzer
							-- settings from .editorconfig.
							EnableEditorConfigSupport = true,
							-- Specifies whether 'using' directives should be grouped and sorted during
							-- document formatting.
							OrganizeImports = nil,
						},
						MsBuild = {
							-- If true, MSBuild project system will only load projects for files that
							-- were opened in the editor. This setting is useful for big C# codebases
							-- and allows for faster initialization of code navigation features only
							-- for projects that are relevant to code that is being edited. With this
							-- setting enabled OmniSharp may load fewer projects and may thus display
							-- incomplete reference lists for symbols.
							LoadProjectsOnDemand = nil,
						},
						RoslynExtensionsOptions = {
							-- Enables support for roslyn analyzers, code fixes and rulesets.
							EnableAnalyzersSupport = nil,
							-- Enables support for showing unimported types and unimported extension
							-- methods in completion lists. When committed, the appropriate using
							-- directive will be added at the top of the current file. This option can
							-- have a negative impact on initial completion responsiveness,
							-- particularly for the first few completion sessions after opening a
							-- solution.
							EnableImportCompletion = nil,
							-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
							-- true
							AnalyzeOpenDocumentsOnly = nil,
						},
						Sdk = {
							-- Specifies whether to include preview versions of the .NET SDK when
							-- determining which version to use for project loading.
							IncludePrereleases = true,
						},
					},
					capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
					on_attach = function(client, bufnr)
						global_on_attach("c#", client, bufnr)
					end,
				}

				vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
					pattern = {'*.cs'},
					callback = function()
						vim.lsp.buf.format({async=false})
					end,
				})
			end

			-- Javascript/Typescript
			require('lspconfig').tsserver.setup({
				cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/typescript-language-server", "--stdio"},
				on_attach = function(client, bufnr)
					global_on_attach("typescript", client, bufnr)
					local conf = {
						format = {
							semicolons = 'insert'
						}
					}
					client.notify('workspace/didChangeConfiguration', {
						settings = {
							typescript = conf,
							javascript = conf,
						}
					})
				end,
			})

			require('lspconfig').eslint.setup({
				cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/vscode-eslint-language-server", "--stdio"},
				on_attach = function(client, bufnr)
					global_on_attach("eslint", client, bufnr)
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
				settings = {
					html = {
						format = {
							wrapAttributes = "preserve-aligned",
							wrapLineLength = 1000000000000
						}
					}
				},
				on_attach = function(client, bufnr)
					global_on_attach("html", client, bufnr)
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
					global_on_attach("css", client, bufnr)
				end,
			})

			-- Zig
			require('lspconfig').zls.setup({
				on_attach = function(client, bufnr)
					global_on_attach("zig", client, bufnr)
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


			-- Go
			require('lspconfig').gopls.setup({
				cmd = { 'gopls',  '-remote.listen.timeout=15s'},
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
				capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
				on_attach = function(client, bufnr)
					global_on_attach("go", client, bufnr)
				end,
			})

			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
			vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
				pattern = {'*.go'},
				callback = function()
					local params = vim.lsp.util.make_range_params()
					params.context = {only = {"source.organizeImports"}}
					-- buf_request_sync defaults to a 1000ms timeout. Depending on your
					-- machine and codebase, you may want longer. Add an additional
					-- argument after params if you find that you have to write the file
					-- twice for changes to be saved.
					-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
					for cid, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
								vim.lsp.util.apply_workspace_edit(r.edit, enc)
							end
						end
					end
					vim.lsp.buf.format({async = false})
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
			local luasnip = require('luasnip')

			-- nvim-cmp setup
			local cmp = require('cmp')
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
				}
			}
		end
	}
})
