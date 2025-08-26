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

			-- removeOilPrefix removes the "oil://" prefix from the buffer name,
			-- so that df and dg keymaps work properly inside oil file tree.
			local function removeOilPrefix(str)
				local prefix = "oil://"
				if string.sub(str, 1, #prefix) == prefix then
					return string.sub(str, #prefix + 1)
				end
				return str
			end

			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>df", function() builtin.find_files({ cwd = removeOilPrefix(utils.buffer_dir()) }) end)
			vim.keymap.set("n", "<leader>dg", function() builtin.live_grep({ cwd = removeOilPrefix(utils.buffer_dir()) }) end)
		end

	},
	{
		"julienvincent/hunk.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = { "DiffEditor" },
		config = function()
			require("hunk").setup({
				ui = {
					tree = {
						mode = "flat",
					},
				},
			})
		end,
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
		"folke/flash.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
		},
		config = function()
			require("flash").setup({
				mode = "fuzzy",
				modes = {
					char = {
						enabled = false,
					},
				},
			})
			-- Based on https://github.com/LazyVim/LazyVim/discussions/1313
			vim.api.nvim_command("hi clear FlashLabel")
			vim.api.nvim_command("hi FlashLabel guibg=#000000 guifg=#FFFFFF")
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
		'neovim/nvim-lspconfig',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/nvim-cmp',
			'L3MON4D3/LuaSnip',
			'ray-x/lsp_signature.nvim',
		},
		config = function()
			function global_on_attach(lsp, client, bufnr)
				local bufopts = { noremap=true, silent=true, buffer=bufnr }

				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

				vim.keymap.set({'v', 'n'}, '<space>a', vim.lsp.buf.code_action, bufopts)
				if lsp == "typos_lsp" then
					return
				end

				local function on_list(original_win)
					return function(items, title, context)
						-- Based on https://www.reddit.com/r/neovim/comments/13nvq2l/how_to_get_references_without_focus_on_quickfix/
						vim.fn.setqflist({}, " ", items)
						vim.cmd.copen()
						vim.api.nvim_set_current_win(original_win)
					end
				end

				vim.keymap.set("n", "gd", function()
					local win = vim.api.nvim_get_current_win()
					vim.lsp.buf.definition(nil, { on_list = on_list(win) })
				end)
				vim.keymap.set("n", "gt", function()
					local win = vim.api.nvim_get_current_win()
					vim.lsp.buf.type_definition(nil, { on_list = on_list(win) })
				end)
				vim.keymap.set("n", "gr", function()
					local win = vim.api.nvim_get_current_win()
					vim.lsp.buf.references(nil, { on_list = on_list(win) })
				end)
				vim.keymap.set("n", "gi", function()
					local win = vim.api.nvim_get_current_win()
					vim.lsp.buf.implementation(nil, { on_list = on_list(win) })
				end)

				vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
				vim.keymap.set('n', '<C-space>', vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
				vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)

				require('lsp_signature').on_attach(client, bufnr)
			end

			-- format on save
			vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
				buffer = bufnr,
				callback = function(args)
					local formattingAvail = false
					for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
						if client.supports_method("textDocument/formatting") then
							formattingAvail = true
						end
					end
					if not formattingAvail then
						return
					end

					if vim.bo[args.buf].filetype == "go" then
						-- Based on: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
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
					end

					vim.lsp.buf.format({async=false})

					if vim.bo[args.buf].filetype == "zig" then
						vim.defer_fn(function()
							-- For some reason zls started to open the Location List, close it.
							vim.cmd.lclose()
						end, 0)
					end
				end,
			})

			vim.lsp.config("gopls", {
				cmd = { 'gopls',  '-remote.listen.timeout=15s'},
				settings = {
					gopls = {
						analyses = {
							unusedwrite = true,
							nilness = true,
							useany = true,
							unusedparams = true,
							shadow = true,
						},
						hints = {
							ignoredError = true,
						},
						staticcheck = true,
					},
				},
				capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
				on_attach = function(client, bufnr)
					global_on_attach("gopls", client, bufnr)
				end,
			})
			vim.lsp.enable("gopls")

			vim.lsp.config("ts_ls", {
				cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/typescript-language-server", "--stdio"},
				on_attach = function(client, bufnr)
					global_on_attach("tsserver", client, bufnr)
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
			vim.lsp.enable("ts_ls")

			vim.lsp.config("eslint", {
				cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/vscode-eslint-language-server", "--stdio"},
				on_attach = function(client, bufnr)
					global_on_attach("eslint", client, bufnr)
				end,
			})
			vim.lsp.enable("eslint")

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			vim.lsp.config("html", {
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
			vim.lsp.enable("html")

			vim.lsp.config("cssls", {
				capabilities = capabilities,
				cmd = {"/home/mateusz/.config/nvim/lua/config/node_modules/.bin/vscode-css-language-server", "--stdio"},
				on_attach = function(client, bufnr)
					global_on_attach("cssls", client, bufnr)
				end,
			})
			vim.lsp.enable("cssls")

			function simple_lsp(lsp)
				vim.lsp.config(lsp, {
					on_attach = function(client, bufnr)
						global_on_attach(lsp, client, bufnr)
					end,
				})
				vim.lsp.enable(lsp)
			end

			simple_lsp("pyright")
			simple_lsp("ruff")
			simple_lsp("typos_lsp")
			simple_lsp("zls")


			--require('lspconfig').golangci_lint_ls.setup{
			--	init_options = {
			--		--command = { "golangci-lint", "run", "--enable-all", "--disable", "exhaustivestruct,exhaustruct,wsl,gofumpt", "--out-format", "json" };
			--		--command = { "golangci-lint", "run", "--out-format", "json" };
			--	}
			--}

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
					{ name = 'buffer' }
				}
			}
		end
	}
})
