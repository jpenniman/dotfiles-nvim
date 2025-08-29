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

local opts = { noremap = true, silent = true }

map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
map("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
map("n", "<F9>", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
map("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
-- map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
map("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
map("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)
map("n", "<leader>dt", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
  { noremap = true, silent = true, desc = 'debug nearest test' })

-- local dapui = require("dapui")
--
-- dapui.setup({
--   expand_lines = true,
--   controls = { enabled = false }, -- no extra play/step buttons
--   floating = { border = "rounded" },
--   render = {
--     max_type_length = 60,
--     max_value_lines = 200,
--   },
--   -- Only one layout: just the "scopes" (variables) list at the bottom
--   layouts = {
--     {
--       elements = {
--         { id = "scopes", size = 1.0 }, -- 100% of this panel is scopes
--       },
--       size = 20,                       -- height in lines (adjust to taste)
--       position = "bottom",             -- "left", "right", "top", "bottom"
--     },
--   },
-- })
--
-- -- Auto open/close UI with sessions
-- dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
-- -- dap.listeners.after.event_initialized["dapui_config"] = function() dapui.float_element("scopes", {}) end
--
-- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
-- dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end
--
-- -- Optional: a simple toggle key if you want manual control sometimes
-- vim.keymap.set("n", "<leader>du", function() dapui.toggle() end,
--   { noremap = true, silent = true, desc = "Toggle DAP UI" })
