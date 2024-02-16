local M = {}

function M.attach(_, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    command = "EslintFixAll",
  })
end

return M
