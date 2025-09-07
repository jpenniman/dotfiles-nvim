local neotest = require("neotest")

local function setup(map, opts)
  map("n", "<leader>dt", function() neotest.run.run({ strategy = 'dap' }) end,
    { noremap = true, silent = true, desc = "debug nearest test" })
  map("n", "<F6>", function() neotest.run.run({ strategy = 'dap' }) end,
    { noremap = true, silent = true, desc = "debug nearest test" })
end

return setup
