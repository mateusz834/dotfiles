require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'folke/tokyonight.nvim'
	use 'simeji/winresizer'
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/nvim-cmp'
	use 'L3MON4D3/LuaSnip'
	use 'ray-x/lsp_signature.nvim'
	use 'ray-x/go.nvim'
	use 'ray-x/guihua.lua'
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use 'akinsho/toggleterm.nvim'

	use {
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	}
end)
