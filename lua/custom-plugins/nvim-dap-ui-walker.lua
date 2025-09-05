local M = {}

-- Expand all collapsed nodes in the *focused* nvim-dap-ui Scopes buffer.
function M.DapUI_SendEnter()
  local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
  vim.api.nvim_feedkeys(cr, "m", false) -- "m" = apply mappings (needed for dap-ui)

  vim.notify("executed DapUI_SendEnter", vim.log.levels.INFO)
  vim.cmd("redraw")
  vim.notify("executed redraw", vim.log.levels.INFO)
end

-- Only presses Enter to expand if:
--  1) the line shows the collapsed icon, and
--  2) the line DOESN'T contain any blocked text.
-- opts.block can be: string | {strings...} | function(line)->boolean
-- opts.insensitive defaults to true (case-insensitive match for block).
function M.DapUI_EnterIfCollapsed(opts)
  opts = opts or {}
  local block = opts.block
  local insensitive = (opts.insensitive ~= false) -- default: case-insensitive

  local icons = require("dapui.config").icons or {}
  local icon = icons.collapsed or ""

  -- (optional) safe log; icons.collapsed can be nil
  -- vim.notify("icons.collapsed: " .. tostring(icons.collapsed), vim.log.levels.DEBUG)

  local line = vim.api.nvim_get_current_line() or ""

  -- --- block check ----------------------------------------------------------
  local function contains(hay, needle)
    if insensitive then
      return hay:lower():find(needle:lower(), 1, true) ~= nil
    else
      return hay:find(needle, 1, true) ~= nil
    end
  end

  local function is_blocked(s)
    if not block then return false end
    local t = type(block)
    if t == "string" then
      return contains(s, block)
    elseif t == "table" then
      for _, b in ipairs(block) do
        if type(b) == "string" and contains(s, b) then return true end
        if type(b) == "function" and b(s) then return true end
      end
      return false
    elseif t == "function" then
      return block(s)
    end
    return false
  end

  if is_blocked(line) then
    vim.notify("Blocked by rule; not expanding", vim.log.levels.WARN)
    return
  end
  -- -------------------------------------------------------------------------

  local _, e = line:find("^%s*" .. vim.pesc(icon) .. "%s+")
  if not e then
    vim.notify("No collapsed marker on this line", vim.log.levels.INFO)
    return
  end

  -- Move cursor to start of the name (right after icon + spaces), then <CR>.
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, { row, e }) -- e (1-based end) -> 0-based col = e
  M.DapUI_SendEnter()
  return true
end

-- Walk down the current Scopes buffer, expanding as we go, until we hit `target`.
-- Usage (cursor already in Scopes window at the start line):
--   :lua DapUI_WalkExpandUntil("PoNatuerlichePerson")
-- function M.DapUI_WalkExpandUntil(target, opts)
--   opts = opts or {}
--
--   local insensitive = (opts.insensitive ~= false) -- default: true
--   local wait_ms = opts.wait_ms or 1000            -- small wait after expansions
--   local center_on_hit = (opts.center ~= false)    -- default: center when found
--
--   if type(target) ~= "string" or target == "" then
--     vim.notify("DapUI_WalkExpandUntil: target must be a non-empty string", vim.log.levels.ERROR)
--     return
--   end
--
--   local buf = vim.api.nvim_get_current_buf()
--   local ft = vim.bo[buf].filetype
--   if ft ~= "dapui_scopes" and ft ~= "dap-float" then
--     vim.notify("Focus the nvim-dap-ui Scopes window first", vim.log.levels.WARN)
--     return
--   end
--
--   local current = vim.api.nvim_win_get_cursor(0)[1]
--   local needle = insensitive and target:lower() or target
--
--   while true do
--     local line_count = vim.api.nvim_buf_line_count(buf)
--
--     vim.notify("line_count: " .. line_count, vim.log.levels.INFO)
--
--     if current > line_count then
--       vim.notify("Target not found below cursor: " .. target, vim.log.levels.INFO)
--       return
--     end
--
--     -- Move to line `current`
--     vim.api.nvim_win_set_cursor(0, { current, 0 })
--     local line = (vim.api.nvim_buf_get_lines(buf, current - 1, current, false)[1] or "")
--     local hay = insensitive and line:lower() or line
--
--     -- Found?
--     if hay:find(needle, 1, true) then
--       vim.notify("NEEDLE FOUND" .. target, vim.log.levels.INFO)
--       if center_on_hit then vim.cmd("normal! zz") end
--       return
--     end
--
--     -- Try to expand this row if it's collapsible
--     if type(M.DapUI_EnterIfCollapsed) == "function" then
--       M.DapUI_EnterIfCollapsed()
--     end
--     -- if type(M.DapUI_SendEnter) == "function" then
--     --   M.DapUI_SendEnter()
--     -- end
--
--
--
--     -- Give dap-ui a moment to render new children when something expanded
--     vim.wait(wait_ms)
--     -- vim.cmd("redraw")
--
--     current = current + 1
--   end
-- end

-- Async walk: move down line-by-line in the Scopes buffer, expanding as we go,
-- until we hit a line containing `target`. Case-insensitive by default.
-- Usage: :lua DapUI_WalkExpandUntilAsync("PoNatuerlichePerson", { interval=120 })
function M.DapUI_WalkExpandUntilAsync(target, opts)
  opts                    = opts or {}
  local interval          = opts.interval or 120        -- ms between steps
  local insensitive       = (opts.insensitive ~= false) -- target matching
  local block             = opts.block                  -- strings|func|mixed
  local block_insensitive = (opts.block_insensitive ~= nil) and opts.block_insensitive or insensitive
  local center_on_hit     = (opts.center ~= false)

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

  local lnum   = vim.api.nvim_win_get_cursor(win)[1]
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
    local hay  = insensitive and line:lower() or line

    -- stop on match
    if hay:find(needle, 1, true) then
      if center_on_hit then vim.cmd("normal! zz") end
      return
    end

    -- try to expand this line (respects block list & collapsed icon)
    if type(M.DapUI_EnterIfCollapsed) == "function" then
      M.DapUI_EnterIfCollapsed({
        block = block,
        insensitive = block_insensitive, -- for block matching
      })
    end

    lnum = lnum + 1
    vim.defer_fn(step, interval) -- yield so UI processes <CR> & re-renders
  end

  step()
end

-- :DapUIWalk <target>  (passes a block list through)
vim.api.nvim_create_user_command("DapUIWalk", function(opts)
  M.DapUI_WalkExpandUntilAsync(opts.args, {
    interval = 100,
    block = { "Static", " _" }, -- your block strings
    -- block_insensitive = true,  -- (optional) case-insensitivity for block
    -- insensitive = true,        -- (optional) case-insensitivity for target
  })
end, { nargs = 1 })

return M
