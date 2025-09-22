-- !!! https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ansiblels", "eslint", "jsonls", "ts_ls", "yamlls" }

-- lsps with default config
require("nvchad.configs.lspconfig").defaults()
vim.lsp.enable(servers)

-- keep filetype detection
vim.cmd([[ autocmd BufNewFile,BufRead *.bicep set filetype=bicep ]])

-- path to the DLL
local bicep_lsp_bin =
"/home/ramboe/.local/share/nvim/mason/packages/bicep-lsp/extension/bicepLanguageServer/Bicep.LangServer.dll"

vim.lsp.config("bicep", {
  cmd = { "dotnet", bicep_lsp_bin },
  filetypes = { "bicep" },
})

vim.lsp.enable("bicep")

vim.lsp.config("dockerls", {})
vim.lsp.enable("dockerls")

vim.lsp.config("roslyn", {})


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
