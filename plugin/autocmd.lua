-- This file is automatically loaded by lazyvim.config.init.

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- wrap and check for spell in text filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup("wrap_spell"),
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = true
--   end,
-- })

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "dap-float",
    "dap-repl",
    "man",
    "notify",
    "qf",
    "query",
    "git",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "httpResult",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- wrap vim diff buffer
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = augroup("vim_enter"),
  pattern = "*",
  callback = function(event)
    if vim.o.diff then
      vim.wo.wrap = true
    end
  end,
})

-- auto update when BufLeave
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = function()
    local buffer_readable = vim.fn.filereadable(vim.fn.bufname("%")) > 0
    if not vim.bo.readonly and buffer_readable then
      vim.cmd("update")
    end
  end,
})

-- fcitx5 rime auto switch to asciimode
if vim.fn.has("fcitx5") then
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    group = augroup("fcitx5_rime"),
    pattern = "*",
    callback = function(event)
      vim.cmd(
        "silent call system('busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b 1')"
      )
    end,
  })
end

-- sync wsl clipboard
if vim.fn.has("wsl") then
  vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = augroup("wsl_yank"),
    pattern = "*",
    callback = function(event)
      vim.cmd("call system('/mnt/c/windows/system32/clip.exe ',@\")")
    end,
  })
end
