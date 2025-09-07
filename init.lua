vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
  require "options"
end)


-- require("custom-config.gen-nvim")
-- require("custom-plugins.clemens-tree")
-- require("custom-plugins.gen.init")

--[[ load plugins with configuration ]]

require("custom-config.oil-config")
require("custom-config.folding")
require("custom-config.scrolling")
require("custom-config.luasnip")
require("custom-config.centerpad")
require("custom-config.neotest")
require("custom-config.tiny-inline-diagnostic")
require("custom-config.fzf-lua")

require("Comment").setup()
require("git-conflict")
require("dap-scope-walker").setup()

-- wtf is this?
-- do
--   local sev      = vim.diagnostic.severity
--   sev[sev.ERROR] = sev[sev.ERROR] or "ERROR"
--   sev[sev.WARN]  = sev[sev.WARN] or "WARN"
--   sev[sev.INFO]  = sev[sev.INFO] or "INFO"
--   sev[sev.HINT]  = sev[sev.HINT] or "HINT"
-- end



-- enable treesitter for razor files
-- vim.filetype.add { extension = { razor = "razor" } }
-- vim.treesitter.language.register("html", "razor") -- use HTML TS for `:set ft=razor`

vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false
