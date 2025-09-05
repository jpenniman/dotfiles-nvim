local M = {}

-- Expand all collapsed nodes in the *focused* nvim-dap-ui Scopes buffer.
function M.DapUI_SendEnter()
  local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
  vim.api.nvim_feedkeys(cr, "m", false) -- "m" = apply mappings (needed for dap-ui)

  vim.notify("executed DapUI_SendEnter", vim.log.levels.INFO)
  vim.cmd("redraw")
  vim.notify("executed redraw", vim.log.levels.INFO)
end

function M.DapUI_EnterIfCollapsed()
  local icons = require("dapui.config").icons or {}

  local icon = icons.collapsed or ""

  vim.notify("icons.collapsed: " .. icons.collapsed, vim.log.levels.INFO)

  local line = vim.api.nvim_get_current_line() or ""
  local s, e = line:find("^%s*" .. vim.pesc(icon) .. "%s+")
  if not e then
    vim.notify("No collapsed marker on this line", vim.log.levels.INFO)
    return
  end

  -- Move cursor to the start of the name (right after icon + spaces), then hit Enter.
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, { row, e }) -- `e` is 1-based; function expects 0-based col
  M.DapUI_SendEnter()
end

-- Walk down the current Scopes buffer, expanding as we go, until we hit `target`.
-- Usage (cursor already in Scopes window at the start line):
--   :lua DapUI_WalkExpandUntil("PoNatuerlichePerson")
function M.DapUI_WalkExpandUntil(target, opts)
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
    if type(M.DapUI_EnterIfCollapsed) == "function" then
      M.DapUI_EnterIfCollapsed()
    end
    -- if type(M.DapUI_SendEnter) == "function" then
    --   M.DapUI_SendEnter()
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
function M.DapUI_WalkExpandUntilAsync(target, opts)
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

    if type(M.DapUI_EnterIfCollapsed) == "function" then
      M.DapUI_EnterIfCollapsed() -- this presses mapped <CR> if the line is collapsible
    end

    lnum = lnum + 1
    vim.defer_fn(step, interval) -- yield to event loop so <CR> is processed and UI updates
  end

  step()
end

-- Nice-to-haves --------------------------------------------------------------
-- :DapUIWalk <target>
vim.api.nvim_create_user_command("DapUIWalk", function(opts)
  M.DapUI_WalkExpandUntilAsync(opts.args, { interval = 100 })
end, { nargs = 1 })

return M
