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

require('telescope').setup {
  defaults = {
    layout_config = {
      vertical = { width = 0.8 },
      horizontal = { width = 0.8 }
      -- other layout configuration here
    },
    -- other defaults configuration here
  },
  pickers = {
    live_grep = {
      theme = "dropdown",
    },
    find_files = {
      -- doesn't work, still get garbage results
      additional_args = function()
        return { "--fixed-strings" } -- disables regex & fuzzy, matches literally
      end,
      theme = "dropdown",
    },
    -- https://github.com/nvim-telescope/telescope.nvim/issues/3075
    -- marks = {
    --   attach_mappings = function(_, map)
    --     map({ "i", "n" }, "<C-d>", require("telescope.actions").delete_mark)
    --     return true
    --   end,
    -- },
  },
  extensions = {
    -- ...
  }
}

-- require("nvim-tree").setup {
--   diagnostics = {
--     enable = true
--   },
--   view = {
--     -- side = 'right',
--     side = "left",
--     width = 45,
--   },
-- }

-- require("smartcolumn").setup()
require("Comment").setup()

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"


vim.schedule(function()
  require "mappings"
  require "options"
end)


-- override color of inactive relative line numbers
-- https://www.color-hex.com/color/d5c4a1
-- vim.cmd([[highlight LineNr guifg=#958970 gui=NONE]])

-- Function to get the RGB color of a highlight group
-- local function get_font_color(highlight_group)
--   local hl = vim.api.nvim_get_hl_by_name(highlight_group, true)
--   local fg = hl.fg or hl.foreground
--   if fg then
--     -- Convert from hex to RGB
--     return string.format("#%06x", fg)
--   else
--     return nil
--   end
-- end

-- Example usage to get the font color for 'Normal'
-- local font_color = get_font_color('Normal')
-- print("Font color for 'Normal': " .. font_color)


--[[ load custom plugins and configuration ]]

require("custom-config.gen-nvim")
require("custom-plugins.clemens-tree")

require("custom-plugins.gen.init")

require("custom-config.oil-config")
require("custom-config.folding")
require("custom-config.scrolling")

-- load snippets from path/of/your/nvim/config/my-cool-snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/my-cool-snippets" } })
require("custom-config.luasnip")

--[[ misc config ]]

vim.api.nvim_command('Oil')                                            -- Open Oil file tree on startup
vim.api.nvim_command('autocmd FileType * setlocal formatoptions-=cro') -- prevent from proceeding with comment

require("neotest").setup({
  adapters = {
    require("neotest-dotnet")
  }
})

-- Load the commit viewer module
local commit_viewer = require('commit_viewer')

-- Create a command to show the commit in a floating window
vim.api.nvim_create_user_command('ShowCommit', commit_viewer.show_commit, {})

-- using the command
vim.api.nvim_set_keymap('n', '<leader>z', '<cmd>Centerpad<cr>', { silent = true, noremap = true })

-- or using the lua function
vim.api.nvim_set_keymap('n', '<leader>z', "<cmd>lua require'centerpad'.toggle{ leftpad = 22, rightpad = 22 }<cr>",
  { silent = true, noremap = true })

require("git-conflict")
require("tiny-inline-diagnostic").setup({
  -- ...
  signs = {
    left = "",
    right = "",
    diag = "●",
    arrow = "    ",
    up_arrow = "    ",
    vertical = " │",
    vertical_end = " └",
  },
  blend = {
    factor = 0.22,
  },
  -- ...
})

do
  local sev      = vim.diagnostic.severity
  sev[sev.ERROR] = sev[sev.ERROR] or "ERROR"
  sev[sev.WARN]  = sev[sev.WARN] or "WARN"
  sev[sev.INFO]  = sev[sev.INFO] or "INFO"
  sev[sev.HINT]  = sev[sev.HINT] or "HINT"
end

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

  -- diagnostics = {
  --   format = function(d)
  --     local sev_labels = { [1] = "Error", [2] = "Warning", [3] = "Info", [4] = "Hint" }
  --     local label = sev_labels[d.severity] or "Unknown"
  --     return string.format(" [%s] %s:%d:%d: %s",
  --       label, d.filename or "?", d.lnum or 0, d.col or 0, d.message or "")
  --   end,
  -- },
  -- diagnostics = {
  --   -- custom line formatter for diagnostics_* pickers
  --   format = function(d)
  --     -- numeric -> "ERROR"/"WARN"/"INFO"/"HINT"
  --     local sev_key    = vim.diagnostic.severity[d.severity] or "UNKNOWN"
  --     -- prettify
  --     local sev_pretty = ({
  --       ERROR = "Error",
  --       WARN  = "Warning",
  --       INFO  = "Info",
  --       HINT  = "Hint",
  --     })[sev_key] or sev_key
  --
  --     -- 0-based -> 1-based
  --     local lnum       = (d.lnum or 0) + 1
  --     local col        = (d.col or 0) + 1
  --
  --     -- include code if present (e.g. CS1998)
  --     local code       = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code) or ""
  --
  --     if code ~= "" then
  --       return string.format(" [%s] %s:%d:%d (%s): %s",
  --         sev_pretty, d.filename or "?", lnum, col, code, d.message or "")
  --     else
  --       return string.format(" [%s] %s:%d:%d: %s",
  --         sev_pretty, d.filename or "?", lnum, col, d.message or "")
  --     end
  --   end,
  -- },
})
-- use `fzf-lua` for replace vim.ui.select
require("fzf-lua").register_ui_select()

vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false
