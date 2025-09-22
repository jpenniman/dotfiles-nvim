-- !!! https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = { "html", "cssls", "ansiblels", "eslint", "jsonls", "ts_ls", "yamlls", "dockerls" }

-- lsps with default config
require("nvchad.configs.lspconfig").defaults()
vim.lsp.enable(servers)

-- BICEP
vim.filetype.add({ extension = { bicep = "bicep" } }) -- filetype detection because nvim does not know .bicep natively

local bicep_mason_path = vim.fn.stdpath("data") ..
    "/mason/packages/bicep-lsp/extension/bicepLanguageServer/Bicep.LangServer.dll"

vim.lsp.config("bicep", {
  cmd = { "dotnet", bicep_mason_path },
  filetypes = { "bicep" },
})
vim.lsp.enable("bicep")
-- END BICEP

vim.lsp.config("roslyn", {}) -- no vim.lsp.enable() necessary here

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
