return {

	-- ColorScheme:
	{
		"ray-x/starry.nvim",
		opts = {
			contrast = {
				enable = true,
				terminal = true,
			},
			text_contrast = {
				darker = true,
			},
			disable = {
				background = true, -- true: transparent background
			},
			style = {
				name = "monokai",
				disable = { "bold" },
				darker_contrast = true,
				deep_black = true,
			},
			custom_colors = {
				variable = "#00ABB3", -- Bondi Blue,
			},
			custom_highlights = {
				["@variable"] = { fg = "#A6CDC6" }, -- Set variables to a pink color
				["@field"] = { fg = "#00ABB3" }, -- Set struct fields to Bondi Blue
			},
		},
	},

	-- Configure LazyVim to load the ColorScheme:
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "starry",
		},
	},
}
