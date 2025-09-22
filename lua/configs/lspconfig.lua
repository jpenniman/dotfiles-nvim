-- !!! https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "ansiblels", "eslint", "jsonls", "ts_ls","yamlls" }

-- lsps with default config
require("nvchad.configs.lspconfig").defaults()
vim.lsp.enable(servers)

lspconfig.vls.setup {}

-- vim.lsp.config('azure_pipelines_ls', {
--   -- other configuration
--   settings = {
--       yaml = {
--           schemas = {
--               ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
--                   -- "/azure-pipeline*.y*l",
--                   "/azure-cli*.y*l",
--                   "/*.azure*",
--                   "Azure-Pipelines/**/*.y*l",
--                   "Pipelines/*.y*l",
--               },
--           },
--       },
--   },
-- })

-- vim.lsp.enable('azure_pipelines_ls')

-- bicep LSP
vim.cmd([[ autocmd BufNewFile,BufRead *.bicep set filetype=bicep ]])

local bicep_lsp_bin =
"/home/ramboe/.local/share/nvim/mason/packages/bicep-lsp/extension/bicepLanguageServer/Bicep.LangServer.dll"

lspconfig.bicep.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "dotnet", bicep_lsp_bin },
  filetypes = { "bicep" }
})
-- END bicep LSP

lspconfig.dockerls.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "Dockerfile" }
})

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
