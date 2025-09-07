require("fzf-lua").setup({
  -- preview window is in fullscreen and takes 70% of the space and is above the search results
  winopts = {
    fullscreen = true,
    preview = {
      layout = "vertical",
      vertical = "up:70%",
    },
  },

  -- use exact string matching, but only for the files picker
  files = {
    fzf_opts = {
      ['--exact'] = '',
      ['--no-sort'] = '',
    }
  },

  -- use cltr-q to select all items and convert to quickfix list (as in telescope)
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },

  diagnostics = {
    cwd_only       = false,
    file_icons     = false,
    git_icons      = false,
    color_headings = true, -- use diag highlights to color source & filepath
    diag_icons     = true, -- display icons from diag sign definitions
    diag_source    = true, -- display diag source (e.g. [pycodestyle])
    diag_code      = true, -- display diag code (e.g. [undefined])
    icon_padding   = '',   -- add padding for wide diagnostics signs
    multiline      = 2,    -- split heading and diag to separate lines
    -- severity_only  = 1
    -- severity_only:   keep any matching exact severity
    -- severity_limit:  keep any equal or more severe (lower)
    -- severity_bound:  keep any equal or less severe (higher)
  }
})
-- use `fzf-lua` for replace vim.ui.select
require("fzf-lua").register_ui_select()

-- local opts = { noremap = true, silent = true }
-- local map = vim.keymap.set
--
-- map("n", "gm", require("fzf-lua").marks, opts)
--
-- -- show all diagnostics
-- map("n", "<leader>da", require("fzf-lua").diagnostics_workspace, opts)
--
-- -- show only errors
-- map("n", "<leader>ds", function()
--   require("fzf-lua").diagnostics_workspace({
--     severity_only = 1 })
-- end, opts)
--
-- map("n", "gr", require("fzf-lua").lsp_references, opts)
-- map("n", "gR", require("fzf-lua").lsp_references, opts)
-- map("n", "<leader>fs", require("fzf-lua").lsp_document_symbols, opts)
-- map("n", "<leader>i", require("fzf-lua").lsp_implementations, opts)
--
-- map("n", "T", require("fzf-lua").buffers, { noremap = true, silent = true, desc = "open buffers" })
--
-- -- override nvchad
-- map("n", "<leader>ff", require("fzf-lua").files, opts)
-- map("n", "<leader>fw", require("fzf-lua").live_grep, opts)
-- map("n", "<leader>gt", require("fzf-lua").git_status, opts)
-- map("n", "<leader>fo", require("fzf-lua").oldfiles, opts)
-- map("n", "<leader>qo", require("fzf-lua").quickfix, opts)
-- map("n", "<leader>qO", require("fzf-lua").lgrep_quickfix, opts)
-- map("n", "<leader>ca", require("fzf-lua").lsp_code_actions, opts)
-- map("n", "<leader>?", require("fzf-lua").builtin, opts)
