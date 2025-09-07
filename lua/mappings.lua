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
-- Oil.nvim
map("n", "<A-a>", "<cmd>Oil<CR>", opts)

-- Comment.nvim
function ToggleComment()
  require('Comment.api').toggle.linewise.current()
end

-- -- Create a command for it
vim.api.nvim_create_user_command('ToggleComment', ToggleComment, {})

-- -- Map Ctrl-k followed by c to toggle comments
vim.api.nvim_set_keymap('n', '<C-k>c', ':ToggleComment<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k><C-c>', ':ToggleComment<CR>', { noremap = true, silent = true })

-- Show File in Tree
map("n", "<leader>e", "<cmd>ShowFileInTree<CR>", opts)
