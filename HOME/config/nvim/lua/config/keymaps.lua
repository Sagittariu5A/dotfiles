-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Resize window using <Shift> arrow keys
map("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Split windows
map("n", "<leader>wj", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>ws", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>wl", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Move selected text up and down using <Shift> j/Down k/Up
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Selected Text/Line Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Selected Text/Line Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Selected Text/Line Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Selected Text/Line Up" })
map("v", "<A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Selected Text/Line Down" })
map("v", "<A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Selected Text/Line Up" })

-- Keep Selected text in visual mode, don’t copy the replacement
map("v", "p", '"_dP', { desc = "Keep selected text on paste in visual mode" })

-- Copy with <C-c>, Paste with <C-v>, and Cut with <C-x> in visual mode
map("v", "<C-c>", '"+y', { desc = "Copy to clipboard" }) -- Copy selection to system clipboard
map("v", "<C-v>", '"+p', { desc = "Paste from clipboard" }) -- Paste from system clipboard
map("v", "<C-x>", '"+d', { desc = "Cut to clipboard" }) -- Cut selection to system clipboard

-- Copy with <C-c> and Paste with <C-v> and Cut with <C-x> in normal mode
map("n", "<C-c>", '"+yy', { desc = "Copy line to clipboard" }) -- Copy current line to system clipboard
map("n", "<C-v>", '"+p', { desc = "Paste from clipboard" }) -- Paste from system clipboard
map("n", "<C-x>", '"+dd', { desc = "Cut line to clipboard" }) -- Cut current line to system clipboard
