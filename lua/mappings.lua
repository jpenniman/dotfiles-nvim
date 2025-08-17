require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- require("mappings_telescope")(map, opts)
require("mappings_fzflua")(map, opts)
-- require("mappings_omnisharp_extended")(map, opts)
require("mappings_lsp")(map, opts)

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

-- map("n", "<leader>ff", "^vf{%j%V", { desc = "highlight function with body" })

-- Define a Lua function to highlight the C# method
function HighlightCSharpMethod()
  -- Jump to the beginning of the line
  -- vim.api.nvim_input('^vf{%j%V')
  vim.api.nvim_input "0"
  -- Enter visual mode
  vim.api.nvim_input "v"
  -- Move to the next "{" character
  vim.api.nvim_input "/{<CR>"
  -- Move to the matching "}" character
  vim.api.nvim_input "%"
  vim.api.nvim_input "V"
end

map("n", "<leader>aa", ":lua HighlightCSharpMethod()<CR>", { noremap = true, silent = true })
map('v', '<leader>as', ':Gen Summarize_Function<CR>')

-- quickfix window
-- map("n", "<leader>qo", "<cmd>copen<CR>", opts)
map("n", "<leader>qc", "<cmd>cclose<CR>", opts)



-- map("n", "<leader>e", "<cmd>NvimTreeFindFile<CR>", opts)
-- map("n", "<A-^[OP>", "<cmd>NvimTreeFindFile<CR>", opts)
-- map("n", "<A-a>", "<cmd>NvimTreeFindFile<CR>", opts)
map("n", "<A-a>", "<cmd>Oil<CR>", opts)

map("n", ";", ":", { desc = "CMD enter command mode" })
map('i', '<C-h>', '<C-w>') -- CTRL+backspace

-- Add a keymap for Shift+Tab to switch to the previous buffer
map("n", "<S-Tab>", ":b#<CR>", opts)

-- close other buffers
function CloseOtherBuffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

vim.api.nvim_create_user_command("CloseOtherBuffers", CloseOtherBuffers, {})
map('n', '<leader>co', ':CloseOtherBuffers<CR>', { noremap = true, silent = true, desc = "close other buffers" })

-- Define a function to toggle comments
function ToggleComment()
  require('Comment.api').toggle.linewise.current()
end

-- Create a command for it
vim.api.nvim_create_user_command('ToggleComment', ToggleComment, {})

-- Map Ctrl-k followed by c to toggle comments
vim.api.nvim_set_keymap('n', '<C-k>c', ':ToggleComment<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k><C-c>', ':ToggleComment<CR>', { noremap = true, silent = true })

-- Show File in Tree

map("n", "<leader>e", "<cmd>ShowFileInTree<CR>", opts)
