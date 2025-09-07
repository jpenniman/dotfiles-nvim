local function setup(map, opts)
  map("n", "<leader>aa", ":lua HighlightCSharpMethod()<CR>", { noremap = true, silent = true })
  map('n', '<leader>co', ':CloseOtherBuffers<CR>', { noremap = true, silent = true, desc = "close other buffers" })
end

return setup
