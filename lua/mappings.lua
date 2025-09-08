require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }


-- override nvchad.mappings here
require("custom-mappings.mappings-fzflua")(map, opts)
require("custom-mappings.mappings-lsp")(map, opts)

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map('v', '<leader>as', ':Gen Summarize_Function<CR>')

map("n", ";", ":", { desc = "CMD enter command mode" })
map('i', '<C-h>', '<C-w>') -- CTRL+backspace

-- Add a keymap for Shift+Tab to switch to the previous buffer
map("n", "<S-Tab>", ":b#<CR>", opts)

-- PLUGIN MAPPINGS


-- Show File in Tree
map("n", "<leader>e", "<cmd>ShowFileInTree<CR>", opts)
