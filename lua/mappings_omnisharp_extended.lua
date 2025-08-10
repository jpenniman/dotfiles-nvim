-- omnisharp_extended bindings

local function setup(map, opts)
  map("n", "gr", "<cmd>lua require('omnisharp_extended').lsp_references()<CR>", opts)
  map("n", "gR", "<cmd>lua require('omnisharp_extended').lsp_references()<CR>", opts)
  map("n", "<F12>", "<cmd>lua require('omnisharp_extended').lsp_definition()<CR>", opts)
end

return setup
