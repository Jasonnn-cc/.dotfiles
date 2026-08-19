local M = {}

--- Copy `text` to both the system clipboard (+) and the unnamed register, then notify.
---@param text string
local function copy(text)
  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)
  vim.notify("Yanked: " .. text)
end

--- Absolute path of the current buffer, or nil (with a warning) when it is not backed by a file.
---@return string|nil
local function buffer_path()
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("No file path for this buffer", vim.log.levels.WARN)
    return nil
  end
  return path
end

--- Yank the absolute path of the current buffer's file.
--- Warns and yanks nothing when the buffer has no file.
function M.absolute_filepath()
  local path = buffer_path()
  if path then
    copy(path)
  end
end

--- Yank the absolute path of the current buffer's file suffixed with the visually selected line range,
--- as `path:line` for a single line or `path:first-last` for several.
--- Warns and yanks nothing when the buffer has no file. Intended for visual/select modes.
function M.absolute_filepath_with_lines()
  local path = buffer_path()
  if not path then
    return
  end
  -- "v" is the visual anchor and "." the cursor; reading both keeps us from having to leave visual
  -- mode to let '< and '> settle, and either end may come first.
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  if first == last then
    copy(string.format("%s:%d", path, first))
  else
    copy(string.format("%s:%d-%d", path, first, last))
  end
end

return M
