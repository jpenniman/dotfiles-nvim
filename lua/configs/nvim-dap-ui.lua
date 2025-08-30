local dapui = require("dapui")

local dap = require("dap")

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })

vim.fn.sign_define('DapBreakpoint',
  {
    text = '', -- nerdfonts icon here
    -- text = '🔴', -- nerdfonts icon here
    texthl = 'DapBreakpointSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })

vim.fn.sign_define('DapStopped',
  {
    text = '', -- nerdfonts icon here
    texthl = 'yellow',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })
vim.fn.sign_define('DapBreakpointRejected',
  {
    text = '', -- nerdfonts icon here
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
      size = 20,                       -- height in lines (adjust to taste)
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
