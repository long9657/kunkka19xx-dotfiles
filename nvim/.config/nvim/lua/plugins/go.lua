return {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup({
			-- go.nvim's codelens.refresh() calls vim.lsp.codelens.enable(),
			-- which only exists on Neovim 0.12+. On 0.11.x this throws on
			-- every save (BufWritePre). Disable until Neovim is upgraded.
			lsp_codelens = false,
		})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
