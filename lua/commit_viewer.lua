
local M = {}

M.show_commit = function()
  -- Execute the get-commit command
  local handle = io.popen("get-commit")
  local result = handle:read("*a")
  handle:close()

  -- Trim any trailing whitespace from the result
  result = result:gsub("%s+$", "")

  -- Create a floating window to display the result
  local buf = vim.api.nvim_create_buf(false, true) -- create new empty buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))

  local width = vim.o.columns
  local height = vim.o.lines
  local win_height = math.ceil(height * 0.3)
  local win_width = math.ceil(width * 0.5)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "single"
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Map 'q' to close the floating window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<CR>', { noremap = true, silent = true })
end

return M
