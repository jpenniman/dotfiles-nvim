-- !!! https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "ansiblels", "eslint", "jsonls", "ts_ls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

vim.cmd([[ autocmd BufNewFile,BufRead *.bicep set filetype=bicep ]])

lspconfig.bicep.setup {}
lspconfig.vls.setup {}

local bicep_lsp_bin =
"/home/ramboe/.local/share/nvim/mason/packages/bicep-lsp/extension/bicepLanguageServer/Bicep.LangServer.dll"

lspconfig.bicep.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "dotnet", bicep_lsp_bin },
  filetypes = { "bicep" }
})

--
lspconfig.dockerls.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "Dockerfile" }
})


-- csharp_ls, https://github.com/razzmatazz/csharp-language-server?tab=readme-ov-file#decompile-for-your-editor--with-the-example-of-neovim

-- !! special workaround for csharpier

-- Create a wrapper on_attach for csharp_ls

vim.lsp.config("roslyn", {})

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  -- on_init = on_init,
  capabilities = capabilities,
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.lsp.start {
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    }
  end
})

-- lspconfig.eslint.setup({
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
--   --- ...
--   -- on_attach = function(client, bufnr)
--   --   vim.api.nvim_create_autocmd("BufWritePre", {
--   --     buffer = bufnr,
--   --     command = "EslintFixAll",
--   --   })
--   -- end,
-- })

-- IMPORTANT: vim diagnostic configuration AFTER LSPs are loaded
vim.diagnostic.config(
  {
    underline = false,
    virtual_text = false,
    update_in_insert = false,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      }
    }
  }
)
