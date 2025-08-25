local M = {}
local augroup = require('wenvim.util').augroup

function M.on_detach(ev)
  local bufnr = ev.buf
  local detach_client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not detach_client then return end
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.id ~= detach_client.id and client.server_capabilities.documentHighlightProvider then return end
  end
  vim.lsp.buf.clear_references()
  local lsp_document_highlight = augroup('lsp_document_highlight', { clear = false })
  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = lsp_document_highlight,
  })
end

function M.on_attach(ev)
  local bufnr = ev.buf
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not client then return end
  if client.server_capabilities.documentHighlightProvider then
    local lsp_document_highlight = augroup('lsp_document_highlight', { clear = false })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = lsp_document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = lsp_document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = lsp_document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
  local opts = { bufnr = bufnr }
  -- inlay hint
  -- TODO change to client:supports_method after nvim 0.12 released
  if client.supports_method('textDocument/inlayHint', opts) then vim.lsp.inlay_hint.enable(true, opts) end
  if vim.fn.has('nvim-0.12') == 1 then vim.lsp.document_color.enable(true, bufnr) end
  -- code lens
  if client.supports_method('textDocument/codeLens', opts) then
    vim.lsp.codelens.refresh(opts)
    vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
      group = augroup('lsp_codelens'),
      buffer = bufnr,
      callback = function() vim.lsp.codelens.refresh(opts) end,
    })
  end
  -- inline completion, only work after neovim commit 58060c2340a52377a0e1d2b782ce1deef13b2b9b
  if client.supports_method('textDocument/inlineCompletion', opts) and vim.lsp.inline_completion then
    vim.lsp.inline_completion.enable(true)
    vim.keymap.set('i', '<M-CR>', function()
      if not vim.lsp.inline_completion.get() then return '<M-CR>' end
    end, {
      expr = true,
      replace_keycodes = true,
      desc = 'Get the current inline completion',
    })
  end
end

-- notice lsp when filename changed, modified from folke snacks.nvim
function M.on_rename_file(from, to)
  local changes = {
    files = { {
      oldUri = vim.uri_from_fname(from),
      newUri = vim.uri_from_fname(to),
    } },
  }

  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method('workspace/willRenameFiles') then
      local resp = client.request_sync('workspace/willRenameFiles', changes, 1000, 0)
      if resp and resp.result ~= nil then vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding) end
    end
  end

  for _, client in ipairs(clients) do
    if client.supports_method('workspace/didRenameFiles') then client.notify('workspace/didRenameFiles', changes) end
  end
end

function M.get_java_cmd()
  local java_home = os.getenv('JAVA21_HOME') or os.getenv('JAVA_HOME')
  return java_home and java_home .. '/bin/java' or 'java'
end

return M
