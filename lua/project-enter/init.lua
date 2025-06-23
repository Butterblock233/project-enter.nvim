---@class project_enter
local M = {}

-- Cache to store project roots that have already been processed to avoid redundant checks.
---@type table<string, boolean>
local cache = {}

--- Finds the project root directory.
-- It searches upwards from the current working directory for common root markers like `.git` or `init.lua`.
-- If no marker is found, it defaults to the current working directory.
-- @return string The absolute path to the project root.
local function get_project_root()
  local cwd = vim.fn.getcwd()
  -- Use vim.fs.find to locate the nearest root marker.
  local root_marker = vim.fs.find({ '.git', 'init.lua' }, { upward = true, path = cwd, type = 'directory' })
  if #root_marker > 0 then
    -- Return the parent directory of the marker.
    return vim.fn.fnamemodify(root_marker[1], ':h')
  end
  -- Fallback to the current working directory if no root is found.
  return cwd
end

--- Triggers the ProjectEnter event detection.
-- This function is intended to be called on events like `VimEnter` and `BufEnter`.
-- It finds the project root, checks for registered `ProjectEnter` patterns,
-- and fires the corresponding autocommand if a file pattern is found in the root.
function M.trigger()
  local root = get_project_root()

  -- If the root has been processed already, or is invalid, do nothing.
  if not root or cache[root] then
    return
  end

  -- Fetch all autocommands registered by lazy.nvim for the 'User' event.
  local events = vim.api.nvim_get_autocmds({ group = 'lazy', event = 'User' })
  ---@type {file: string, original: string}[]
  local patterns_to_check = {}

  -- Iterate through the autocommands to find our custom 'ProjectEnter' patterns.
  for _, event in ipairs(events) do
    if event.pattern and type(event.pattern) == 'string' and event.pattern:find('^ProjectEnter ') then
      -- Extract the file pattern from the event string, e.g., "cargo.toml" from "ProjectEnter cargo.toml".
      local file_pattern = event.pattern:gsub('^ProjectEnter ', '')
      if file_pattern ~= '' and file_pattern ~= '*' then
        table.insert(patterns_to_check, { file = file_pattern, original = event.pattern })
      end
    end
  end

  -- If there are no 'ProjectEnter' patterns to check, mark this root as processed and exit.
  if #patterns_to_check == 0 then
    cache[root] = true
    return
  end

  local triggered = false
  -- Check for the existence of each file pattern in the project root.
  for _, p in ipairs(patterns_to_check) do
    local file_path = root .. '/' .. p.file
    -- Use vim.uv.fs_stat to check if the file exists.
    local stat = vim.uv.fs_stat(file_path)
    if stat then
      -- If the file exists, execute the corresponding autocommand.
      vim.api.nvim_exec_autocmds('User', { pattern = p.original, modeline = false })
      triggered = true
    end
  end

  -- If any event was triggered, cache the root to prevent future checks in this session.
  if triggered then
    cache[root] = true
  end
end

return M
