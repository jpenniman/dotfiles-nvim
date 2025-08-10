-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}


M.base46 = {
  -- theme = "nightowl",
  -- theme = "aquarium",
  -- theme = "mountain",
  -- theme = "falcon-custom",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },

  -- hl_override = {
  --   syntax = {
  --     Type = { bold = true, italic = true },
  --   },
  --
  --   --- https://neovim.io/doc/user/treesitter.html#treesitter-highlight-groups
  --   treesitter = {
  --     ["@function"] = { bold = true, italic = true },
  --     ["@function.builtin"] = { bold = true },
  --     -- ["@function.call"] = { bold = true, fg = M.base_30.dark_purple },
  --     ["@function.call"] = { bold = true },
  --     -- ["@constructor"] = { fg = M.base_30.purple },
  --     -- ["@variable.parameter"] = { fg = M.base_30.white },
  --     -- ["@module"] = { fg = M.base_30.deep_black },
  --     -- ["@symbol"] = { fg = M.base_30.purple },
  --     ["@keyword"] = { italic = true },
  --     ["@function.method.call"] = { bold = true },
  --     -- ["@comment"] = { italic = true, bg = M.base_30.baby_pink },
  --     -- ["@comment"] = { bold = true, italic = true, bg = M.base_30.red },
  --     -- ["@keyword"] = { fg = M.base_16.base0D },
  --   },
  -- }
  hl_override = {
    Type = { bold = true, italic = false },
    ["@comment"] = { italic = true },

    --- https://neovim.io/doc/user/treesitter.html#treesitter-highlight-groups
    ["@function"] = { bold = true, italic = true },
    ["@function.builtin"] = { bold = true },
    ["@function.call"] = { bold = true },
    ["@keyword"] = { italic = true },
    ["@function.method.call"] = { bold = true }
  }
}

-- M.ui = {
--   base46 = {
--     hl_override = {
--       Type = { bold = true, italic = false },
--       ["@comment"] = { italic = true },
--
--       --- https://neovim.io/doc/user/treesitter.html#treesitter-highlight-groups
--       ["@function"] = { bold = true, italic = true },
--       ["@function.builtin"] = { bold = true },
--       ["@function.call"] = { bold = true },
--       ["@keyword"] = { italic = true },
--       ["@function.method.call"] = { bold = true }
--     }
--   }
-- }

return M
