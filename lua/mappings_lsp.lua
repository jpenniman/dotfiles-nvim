-- roslyn bindings

local function setup(map, opts)
  map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  map("n", "<leader>ra", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  map("v", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  -- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- map("n", "gR", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  map("n", "<F12>", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
end

return setup
