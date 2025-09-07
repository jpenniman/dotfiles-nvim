-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}


M.base46 = {

  theme = "pastelbeans",

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


return M
