require("dap-scope-walker").setup()
require("helpers")

local map = vim.keymap.set

map("n", "<leader>aa", function() HighlightCSharpMethod() end,
  { noremap = true, silent = true, desc = "Highlight C# Method Body" })

map("n", "<leader>co", function() CloseOtherBuffers() end,
  { noremap = true, silent = true, desc = "close other buffers" })
