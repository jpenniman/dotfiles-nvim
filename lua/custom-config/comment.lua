require("Comment").setup()

-- Comment.nvim
function ToggleComment()
  require('Comment.api').toggle.linewise.current()
end

-- -- Create a command for it
vim.api.nvim_create_user_command('ToggleComment', ToggleComment, {})

-- -- Map Ctrl-k followed by c to toggle comments
vim.api.nvim_set_keymap('n', '<C-k>c', ':ToggleComment<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k><C-c>', ':ToggleComment<CR>', { noremap = true, silent = true })
