local M = {}

--- Yank the absolute path of the current buffer's file.
--- Writes to both the system clipboard (+) and the unnamed register, and notifies with the copied path.
--- Does nothing but warn when the buffer is not backed by a file.
function M.absolute_filepath()
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("No file path for this buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", path)
  vim.fn.setreg('"', path)
  vim.notify("Yanked: " .. path)
end

return M
