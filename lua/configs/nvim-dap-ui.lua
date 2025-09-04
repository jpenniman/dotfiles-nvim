local dapui = require("dapui")

local dap = require("dap")

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })

-- https://emojipedia.org/en/stickers/search?q=circle
vim.fn.sign_define('DapBreakpoint',
  {
    text = '⚪',
    texthl = 'DapBreakpointSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })

vim.fn.sign_define('DapStopped',
  {
    text = '🔴',
    texthl = 'yellow',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })
vim.fn.sign_define('DapBreakpointRejected',
  {
    text = '⭕',
    texthl = 'DapStoppedSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })

-- more minimal ui
dapui.setup({
  expand_lines = true,
  controls = { enabled = false }, -- no extra play/step buttons
  floating = { border = "rounded" },
  render = {
    max_type_length = 60,
    max_value_lines = 200,
  },
  -- Only one layout: just the "scopes" (variables) list at the bottom
  layouts = {
    {
      elements = {
        { id = "scopes", size = 1.0 }, -- 100% of this panel is scopes
      },
      size = 15,                       -- height in lines (adjust to taste)
      position = "bottom",             -- "left", "right", "top", "bottom"
    },
  },
})

local map, opts = vim.keymap.set, { noremap = true, silent = true }

map("n", "<leader>du", function() dapui.toggle() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })

-- Add word under cursor to Watches
map({ "n", "v" }, "<leader>dw", function() require("dapui").eval(nil, { enter = true }) end, opts)

-- Hover/eval a single value (opens a tiny window instead of expanding the full object)
map({ "n", "v" }, "Q", function() require("dapui").eval() end, opts)


-- EXPERIMENTAL AREA
-- Expand all nodes in the *currently focused* scopes buffer (nvim-dap or nvim-dap-ui)
local function _feed(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'm', false) -- allow mappings
end

-- -- Expand all nodes in the *currently focused* dap scopes buffer using <CR>.
-- -- It only hits lines that look collapsible (based on common glyphs), and
-- -- repeats a few passes until nothing new appears.
-- local function _feed_cr()
--   local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
--   vim.api.nvim_feedkeys(cr, "m", false) -- allow mappings (needed for dap-ui)
-- end
--
-- function _G.DapExpandAllScopes(max_passes)
--   local win = vim.api.nvim_get_current_win()
--   local buf = vim.api.nvim_get_current_buf()
--   local ft = vim.bo[buf].filetype
--   -- Must be in a dap scopes-like buffer
--   if ft ~= "dapui_scopes" and ft ~= "dap-float" then
--     vim.notify("Not in a DAP Scopes buffer", vim.log.levels.WARN)
--     return
--   end
--
--   -- Markers that usually denote a collapsed node. Adjust to your icons if needed.
--   local markers = {"", "▸", "", "", ">", "%)" } -- last one catches some tree renderers
--   -- local markers = { "▸", "", "", ">", "%)" } -- last one catches some tree renderers
--
--   local function is_collapsed(line)
--     for _, m in ipairs(markers) do
--       if line:find(vim.pesc(m)) then return true end
--     end
--     return false
--   end
--
--   max_passes = max_passes or 6
--   for _ = 1, max_passes do
--     local before = vim.api.nvim_buf_line_count(buf)
--     for i = 1, before do
--       local line = (vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1] or "")
--       if is_collapsed(line) then
--         vim.api.nvim_win_set_cursor(win, { i, 0 })
--         _feed_cr() -- expand this node
--       end
--     end
--     vim.cmd("redraw")
--     local after = vim.api.nvim_buf_line_count(buf)
--     if after == before then break end -- nothing more expanded
--   end
-- end
--
-- -- Optional: bind a key only inside scopes buffers
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "dapui_scopes", "dap-float" },
--   callback = function(args)
--     vim.keymap.set("n", "E", function() _G.DapExpandAllScopes() end,
--       { buffer = args.buf, silent = true, desc = "Expand all scopes" })
--   end,
-- })
