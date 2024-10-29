

return {
  -- add OneDark as ColorScheme: https://github.com/navarasu/onedark.nvim
  { 'navarasu/onedark.nvim', },

  -- Configure LazyVim to load onedark
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}

