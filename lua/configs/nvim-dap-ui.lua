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
  -- Set dapui window
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
-- EXPERIMENTAL AREA
-- EXPERIMENTAL AREA
-- EXPERIMENTAL AREA
-- EXPERIMENTAL AREA

-- Expand all collapsed nodes in the *focused* nvim-dap-ui Scopes buffer.
function _G.DapUI_SendEnter()
  local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
  vim.api.nvim_feedkeys(cr, "m", false) -- "m" = apply mappings (needed for dap-ui)

  vim.notify("executed DapUI_SendEnter", vim.log.levels.INFO)
  vim.cmd("redraw")
  vim.notify("executed redraw", vim.log.levels.INFO)
end

function _G.DapUI_EnterIfCollapsed()
  local icons = require("dapui.config").icons or {}
  local icon = icons.collapsed or ""

  local line = vim.api.nvim_get_current_line() or ""
  local s, e = line:find("^%s*" .. vim.pesc(icon) .. "%s+")
  if not e then
    vim.notify("No collapsed marker on this line", vim.log.levels.INFO)
    return
  end

  -- Move cursor to the start of the name (right after icon + spaces), then hit Enter.
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, { row, e }) -- `e` is 1-based; function expects 0-based col
  _G.DapUI_SendEnter()
end

-- Walk down the current Scopes buffer, expanding as we go, until we hit `target`.
-- Usage (cursor already in Scopes window at the start line):
--   :lua DapUI_WalkExpandUntil("PoNatuerlichePerson")
function _G.DapUI_WalkExpandUntil(target, opts)
  opts = opts or {}

  local insensitive = (opts.insensitive ~= false) -- default: true
  local wait_ms = opts.wait_ms or 1000            -- small wait after expansions
  local center_on_hit = (opts.center ~= false)    -- default: center when found

  if type(target) ~= "string" or target == "" then
    vim.notify("DapUI_WalkExpandUntil: target must be a non-empty string", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  if ft ~= "dapui_scopes" and ft ~= "dap-float" then
    vim.notify("Focus the nvim-dap-ui Scopes window first", vim.log.levels.WARN)
    return
  end

  local current = vim.api.nvim_win_get_cursor(0)[1]
  local needle = insensitive and target:lower() or target

  while true do
    local line_count = vim.api.nvim_buf_line_count(buf)

    vim.notify("line_count: " .. line_count, vim.log.levels.INFO)

    if current > line_count then
      vim.notify("Target not found below cursor: " .. target, vim.log.levels.INFO)
      return
    end

    -- Move to line `current`
    vim.api.nvim_win_set_cursor(0, { current, 0 })
    local line = (vim.api.nvim_buf_get_lines(buf, current - 1, current, false)[1] or "")
    local hay = insensitive and line:lower() or line

    -- Found?
    if hay:find(needle, 1, true) then
      vim.notify("NEEDLE FOUND" .. target, vim.log.levels.INFO)
      if center_on_hit then vim.cmd("normal! zz") end
      return
    end

    -- Try to expand this row if it's collapsible
    if type(_G.DapUI_EnterIfCollapsed) == "function" then
      _G.DapUI_EnterIfCollapsed()
    end
    -- if type(_G.DapUI_SendEnter) == "function" then
    --   _G.DapUI_SendEnter()
    -- end



    -- Give dap-ui a moment to render new children when something expanded
    vim.wait(wait_ms)
    -- vim.cmd("redraw")

    current = current + 1
  end
end

-- Async walk: move down line-by-line in the Scopes buffer, expanding as we go,
-- until we hit a line containing `target`. Case-insensitive by default.
-- Usage: :lua DapUI_WalkExpandUntilAsync("PoNatuerlichePerson", { interval=120 })
function _G.DapUI_WalkExpandUntilAsync(target, opts)
  opts = opts or {}
  local interval = opts.interval or 120 -- ms between steps
  local insensitive = (opts.insensitive ~= false)
  local center_on_hit = (opts.center ~= false)

  if type(target) ~= "string" or target == "" then
    vim.notify("Target must be a non-empty string", vim.log.levels.ERROR)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  if ft ~= "dapui_scopes" and ft ~= "dap-float" then
    vim.notify("Focus the nvim-dap-ui Scopes window first", vim.log.levels.WARN)
    return
  end

  local lnum = vim.api.nvim_win_get_cursor(win)[1]
  local needle = insensitive and target:lower() or target

  local function step()
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then return end
    local last = vim.api.nvim_buf_line_count(buf)
    if lnum > last then
      vim.notify("Target not found below cursor: " .. target, vim.log.levels.INFO)
      return
    end

    vim.api.nvim_win_set_cursor(win, { lnum, 0 })
    local line = (vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or "")
    local hay = insensitive and line:lower() or line
    if hay:find(needle, 1, true) then
      if center_on_hit then vim.cmd("normal! zz") end
      return
    end

    if type(_G.DapUI_EnterIfCollapsed) == "function" then
      _G.DapUI_EnterIfCollapsed() -- this presses mapped <CR> if the line is collapsible
    end

    lnum = lnum + 1
    vim.defer_fn(step, interval) -- yield to event loop so <CR> is processed and UI updates
  end

  step()
end

-- Nice-to-haves --------------------------------------------------------------
-- :DapUIWalk <target>
vim.api.nvim_create_user_command("DapUIWalk", function(opts)
  _G.DapUI_WalkExpandUntilAsync(opts.args, { interval = 100 })
end, { nargs = 1 })
