local dap = require("dap")

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

local netcoredbg_adapter = {
  type = "executable",
  command = mason_path,
  args = { "--interpreter=vscode" },
}

dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter    -- needed for unit test debugging

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return require("dap-dll-autopicker").build_dll_path()
    end
  },
}

local map = vim.keymap.set


map("n", "<F5>", function() dap.continue() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })
map("n", "<F8>", function() dap.step_out() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })
map("n", "<F9>", function() dap.toggle_breakpoint() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })
map("n", "<F10>", function() dap.step_over() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })
map("n", "<F11>", function() dap.step_into() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })
map("n", "<leader>dr", function() dap.repl.open() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })
map("n", "<leader>dl", function() dap.run_last() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })


local neotest = require("neotest")
map("n", "<leader>dt", function() neotest.run.run({ strategy = 'dap' }) end,
  { noremap = true, silent = true, desc = "debug nearest test" })
map("n", "<F6>", function() neotest.run.run({ strategy = 'dap' }) end,
  { noremap = true, silent = true, desc = "debug nearest test" })
