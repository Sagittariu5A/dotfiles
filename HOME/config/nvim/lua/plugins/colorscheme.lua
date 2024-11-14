return {

	-- ColorScheme:
	-- { "olimorris/onedarkpro.nvim" },
	{ "tanvirtin/monokai.nvim" },
	-- { "polirritmico/monokai-nightasty.nvim" },

	-- Configure LazyVim to load the ColorScheme:
	{
		"LazyVim/LazyVim",
		opts = {
			-- colorscheme = "onedark_dark",
			colorscheme = "monokai",
			-- colorscheme = "monokai-nightasty",
		},
	},
}
