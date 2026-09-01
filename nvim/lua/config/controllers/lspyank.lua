local M = {}

--- Copy `text` to both the system clipboard (+) and the unnamed register, then notify.
---@param text string
local function copy(text)
  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)
  vim.notify("Yanked: " .. text)
end

--- The signature carried by a hover response's markdown lines: the contents of the first fenced
--- code block, or the first non-empty line when the server sent prose only.
---@param lines string[]
---@return string|nil
local function signature_of(lines)
  local block, in_block = {}, false
  for _, line in ipairs(lines) do
    if line:match("^%s*```") then
      -- The closing fence ends the first block; anything after it is documentation prose.
      if in_block then
        break
      end
      in_block = true
    elseif in_block then
      table.insert(block, line)
    end
  end

  if #block > 0 then
    return vim.trim(table.concat(block, "\n"))
  end

  for _, line in ipairs(lines) do
    if vim.trim(line) ~= "" then
      return vim.trim(line)
    end
  end
  return nil
end

--- Yank the type signature the LSP reports for the symbol under the cursor.
--- Asynchronous: requests hover from every attached client that supports it and yanks the first
--- signature to come back. Warns and yanks nothing when no client supports hover, or when no
--- client has a signature for the symbol.
function M.hover_signature()
  local bufnr = vim.api.nvim_get_current_buf()
  local method = vim.lsp.protocol.Methods.textDocument_hover

  if #vim.lsp.get_clients({ bufnr = bufnr, method = method }) == 0 then
    vim.notify("No LSP client supporting hover for this buffer", vim.log.levels.WARN)
    return
  end

  -- Position params are per-client because each negotiates its own offset encoding.
  local params = function(client)
    return vim.lsp.util.make_position_params(0, client.offset_encoding)
  end

  vim.lsp.buf_request_all(bufnr, method, params, function(results)
    for _, response in pairs(results) do
      local contents = response.result and response.result.contents
      if contents then
        local signature = signature_of(vim.lsp.util.convert_input_to_markdown_lines(contents))
        if signature then
          copy(signature)
          return
        end
      end
    end
    vim.notify("No hover signature under the cursor", vim.log.levels.WARN)
  end)
end

return M
