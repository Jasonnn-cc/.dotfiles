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

--- Root of the git repository containing `dir`, or nil (with a warning) when there is none.
---@param dir string
---@return string|nil
local function git_root(dir)
  -- `.git` is a directory in a normal clone but a file in worktrees and submodules, so match either.
  local found = vim.fs.find(".git", { path = dir, upward = true })[1]
  if not found then
    vim.notify("Not inside a git repository", vim.log.levels.WARN)
    return nil
  end
  return vim.fs.dirname(found)
end

--- Yank the absolute path of the git root containing the current buffer's file,
--- falling back to the current working directory for buffers with no file.
--- Warns and yanks nothing when neither is inside a git repository.
function M.git_root_path()
  local path = vim.fn.expand("%:p:h")
  if path == "" then
    path = vim.fn.getcwd()
  end
  local root = git_root(path)
  if root then
    copy(root)
  end
end

--- `path` made relative to the git root containing it, or nil (with a warning) when it is not
--- inside a git repository.
---@param path string
---@return string|nil
local function relative_to_git_root(path)
  local root = git_root(vim.fs.dirname(path))
  if not root then
    return nil
  end
  -- +2 skips the root itself and the separator that follows it.
  return path:sub(#root + 2)
end

--- The visually selected line range as a path suffix: `:line` for a single line, `:first-last`
--- for several. Intended for visual/select modes.
---@return string
local function line_suffix()
  -- "v" is the visual anchor and "." the cursor; reading both keeps us from having to leave visual
  -- mode to let '< and '> settle, and either end may come first.
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  if first == last then
    return string.format(":%d", first)
  end
  return string.format(":%d-%d", first, last)
end

--- Yank the current buffer's file path relative to its git root.
--- Warns and yanks nothing when the buffer has no file or is not inside a git repository.
function M.git_relative_filepath()
  local path = buffer_path()
  if not path then
    return
  end
  local relative = relative_to_git_root(path)
  if relative then
    copy(relative)
  end
end

--- Yank the current buffer's file path relative to its git root, suffixed with the visually
--- selected line range, as `path:line` for a single line or `path:first-last` for several.
--- Warns and yanks nothing when the buffer has no file or is not inside a git repository.
--- Intended for visual/select modes.
function M.git_relative_filepath_with_lines()
  local path = buffer_path()
  if not path then
    return
  end
  local relative = relative_to_git_root(path)
  if relative then
    copy(relative .. line_suffix())
  end
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
  if path then
    copy(path .. line_suffix())
  end
end

return M
