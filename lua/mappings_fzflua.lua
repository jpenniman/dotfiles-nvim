local function setup(map, opts)
  map("n", "gm", require("fzf-lua").marks, opts)

  -- show all diagnostics
  map("n", "<leader>da", require("fzf-lua").diagnostics_workspace, opts)

  -- show only errors
  map("n", "<leader>ds", function()
    require("fzf-lua").diagnostics_workspace({
      severity_only = 1 })
  end, opts)

  -- default bindings if you want to use an LSP different to omnisharp
  map("n", "gr", require("fzf-lua").lsp_references, opts)
  map("n", "gR", require("fzf-lua").lsp_references, opts)
  map("n", "<leader>fs", require("fzf-lua").lsp_document_symbols, opts)
  map("n", "<leader>i", require("fzf-lua").lsp_implementations, opts)

  map("n", "T", require("fzf-lua").buffers, { noremap = true, silent = true, desc = "open buffers" })

  -- override nvchad
  map("n", "<leader>ff", require("fzf-lua").files, opts)
  map("n", "<leader>fw", require("fzf-lua").live_grep, opts)
  map("n", "<leader>gt", require("fzf-lua").git_status, opts)
  map("n", "<leader>fo", require("fzf-lua").oldfiles, opts)
  map("n", "<leader>qo", require("fzf-lua").quickfix, opts)
  map("n", "<leader>qO", require("fzf-lua").lgrep_quickfix, opts)
  map("n", "<leader>ca", require("fzf-lua").lsp_code_actions, opts)
  map("n", "<leader>?", require("fzf-lua").builtin, opts)
end

return setup
