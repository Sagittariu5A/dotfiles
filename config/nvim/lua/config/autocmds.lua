-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- The whichwrap option specifies which cursor movements can wrap to the previous or next line when the cursor moves past the beginning or end of the line.
vim.cmd("set whichwrap+=<,>,[,],h,l")
-- make nvim to proccess '-' as a part of word (Modifies the characters Vim considers part of a "word".)
vim.cmd([[set iskeyword+=-]])
-- Controls Vim’s automatic text formatting behavior.
vim.cmd([[set formatoptions-=cro]])
