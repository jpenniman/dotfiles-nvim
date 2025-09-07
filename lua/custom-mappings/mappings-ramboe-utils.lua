local function setup(map, opts)
  map("n", "<leader>aa", function() HighlightCSharpMethod() end,
    { noremap = true, silent = true, desc = "Highlight C# Method Body" })

  map("n", "<leader>co", function() CloseOtherBuffers() end,
    { noremap = true, silent = true, desc = "close other buffers" })
end

return setup
