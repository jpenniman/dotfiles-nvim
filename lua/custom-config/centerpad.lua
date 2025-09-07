local centerpad = require("centerpad")

local map = vim.keymap.set

map("n", "<leader>z", function() centerpad.toggle { leftpad = 22, rightpad = 22 } end,
  { noremap = true, silent = true, desc = "Toggle centerpad" })
