local function setup(map, opts)
  map("n", "gm", "<cmd>Telescope marks<CR>", opts)
  map("n", "<leader>da", "<cmd>Telescope diagnostics<CR>", opts)
  map("n", "<leader>ds", "<cmd>lua require('telescope.builtin').diagnostics({ bufnr = 0 })<CR>", opts)

  map("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
  map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", opts)

  map("n", "T", "<Cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "open buffers" })

end


return setup
