-- lua/plugins/typescript.lua
return {
	-- LSP-config
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tsserver = {
					-- hier kun je later extra settings kwijt, bv:
					-- root_dir = function(fname) ... end,
				},
			},
		},
	},

	-- Mason: automatisch de juiste tools installeren
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"typescript-language-server",
				"js-debug-adapter", -- optioneel, voor debugging
			},
		},
	},
}
