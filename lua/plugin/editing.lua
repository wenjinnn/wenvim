local in_vscode = require("util").in_vscode
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local map = require("util").map

later(function()
  local gen_ai_spec = require("mini.extra").gen_ai_spec
  local gen_spec = require("mini.ai").gen_spec
  require("mini.ai").setup({
    custom_textobjects = {
      B = gen_ai_spec.buffer(),
      D = gen_ai_spec.diagnostic(),
      I = gen_ai_spec.indent(),
      L = gen_ai_spec.line(),
      N = gen_ai_spec.number(),
      -- Tweak argument to be recognized only inside `()` between `;`
      a = gen_spec.argument({ brackets = { "%b()" }, separator = ";" }),
      -- Tweak function call to not detect dot in function name
      f = gen_spec.function_call({ name_pattern = "[%w_]" }),
      -- Function definition (needs treesitter queries with these captures)
      -- This need nvim-treesitter-textobjects, see https://github.com/echasnovski/mini.nvim/issues/947#issuecomment-2154242659
      F = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      -- Make `|` select both edges in non-balanced way
      o = gen_spec.treesitter({
        a = { "@conditional.outer", "@loop.outer" },
        i = { "@conditional.inner", "@loop.inner" },
      }),
      c = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      ["|"] = gen_spec.pair("|", "|", { type = "non-balanced" }),
    },
    n_lines = 500,
  })
end)

later(function()
  local gen_hook = require("mini.splitjoin").gen_hook
  local curly = { brackets = { "%b{}" } }
  -- Add trailing comma when splitting inside curly brackets
  local add_comma_curly = gen_hook.add_trailing_separator(curly)
  -- Delete trailing comma when joining inside curly brackets
  local del_comma_curly = gen_hook.del_trailing_separator(curly)
  -- Pad curly brackets with single space after join
  local pad_curly = gen_hook.pad_brackets(curly)
  require("mini.splitjoin").setup({
    split = { hooks_post = { add_comma_curly } },
    join = { hooks_post = { del_comma_curly, pad_curly } },
  })
end)

later(function()
  require("mini.surround").setup()
  vim.keymap.set({ "n", "x" }, "s", "<Nop>")
end)

later(function()
  add({
    source = "nvim-treesitter/nvim-treesitter-textobjects",
    depends = {
      "windwp/nvim-ts-autotag",
      "hiphish/rainbow-delimiters.nvim",
      "nvim-treesitter/nvim-treesitter-context",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter",
    },
    hooks = {
      post_checkout = function()
        vim.cmd("TSUpdate")
      end,
    },
  })
  vim.g.skip_ts_context_commentstring_module = true
  local get_option = vim.filetype.get_option
  -- FIX native comment not work for jsx or vue template, relate issue: https://github.com/neovim/neovim/issues/28830
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.filetype.get_option = function(filetype, option)
    return option == "commentstring"
        and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
  end
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      -- basic
      "vim",
      "vimdoc",
      "regex",
      "markdown",
      "lua",
      "luadoc",
      "luap",
      "query",
      "bash",
      "hurl",
      "diff",
      "markdown_inline",
      "make",
      -- autotag dependencies
      "astro",
      "glimmer",
      "html",
      "javascript",
      "markdown",
      "php",
      "svelte",
      "tsx",
      "typescript",
      "vue",
      "xml",
      -- personal frequently used
      "nix",
      "java",
      "rust",
      "sql",
      "css",
      "scss",
      "yaml",
    }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "org" }, -- List of parsers to ignore installing
    auto_install = true,
    highlight = {
      enable = not in_vscode(), -- false will disable the whole extension
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  })
  require("ts_context_commentstring").setup({
    enable_autocmd = false,
  })
  require("nvim-ts-autotag").setup()
end)

later(function()
  require("mini.align").setup()
  require("mini.bracketed").setup()
  require("mini.pairs").setup()
end)

if not in_vscode() then
  now(function()
    require("mini.sessions").setup({
      -- Whether to force possibly harmful actions (meaning depends on function)
      force = { read = false, write = true, delete = true },
      hooks = {
        -- Before successful action
        pre = { read = nil, write = nil, delete = nil },
        -- After successful action
        post = { read = require("util").delete_dap_terminals, write = nil, delete = nil },
      },
    })
    local session_name = function()
      local cwd = vim.fn.getcwd()
      local parent_path = vim.fn.fnamemodify(cwd, ":h")
      local current_tail_path = vim.fn.fnamemodify(cwd, ":t")
      return string.format("%s@%s", current_tail_path, parent_path:gsub("/", "-"))
    end

    map("n", "<leader>sw",
      function()
        require("mini.sessions").write(session_name())
      end,
      "Session write")
    map("n", "<leader>sW",
      function()
        MiniSessions.write(vim.fn.input("Session name: "))
      end,
      "Session write custom")
    map("n", "<leader>sd",
      function()
        require("mini.sessions").delete(session_name())
      end,
      "Session delete")
    map("n", "<leader>sD",
      function()
        MiniSessions.delete(vim.fn.input("Session name: "))
      end,
      "Session delete custom")
    map("n", "<leader>ss",
      function()
        MiniSessions.select()
      end,
      "Session select")
  end)

  later(function()
    require("mini.bufremove").setup()
    map("n", "<leader>x", "<cmd>lua MiniBufremove.delete()<CR>", "Buf delete")
  end)

  later(function()
    add({ source = "mfussenegger/nvim-lint" })
    local lint = require("lint")
    -- just use the default lint
    -- TODO maybe add more linter in future
    lint.linters_by_ft = {}
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
        lint.try_lint("compiler")
      end,
    })
  end)

  later(function()
    add({ source = "stevearc/conform.nvim" })
    require("conform").setup({
      formatters_by_ft = {
        nix = { "alejandra" },
      },
    })
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.g.conform_autoformat = true
    local diff_format = function()
      local data = MiniDiff.get_buf_data()
      if not data or not data.hunks or not vim.g.conform_autoformat then
        vim.notify("No hunks in this buffer or auto format is currently disabled")
        return
      end
      local ranges = {}
      for _, hunk in pairs(data.hunks) do
        if hunk.type ~= "delete" then
          -- always insert to index 1 so format below could start from last hunk, which this sort didn't mess up range
          table.insert(ranges, 1, {
            start = { hunk.buf_start, 0 },
            ["end"] = { hunk.buf_start + hunk.buf_count, 0 },
          })
        end
      end
      for _, range in pairs(ranges) do
        require("conform").format({ lsp_fallback = true, timeout_ms = 500, range = range })
      end
    end
    vim.api.nvim_create_user_command("DiffFormat", diff_format, { desc = "Format changed lines" })
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = diff_format,
      desc = "Auto format changed lines",
    })

    map("n", "<leader>md", "<cmd>DiffFormat<cr>", "Diff format")
    map({ "n", "v" },
      "<leader>mm",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      "Format")
    map("n", "<leader>mM",
      function()
        vim.g.conform_autoformat = not vim.g.conform_autoformat
        vim.notify("Autoformat: " .. (vim.g.conform_autoformat and "on" or "off"))
      end,
      "Auto format toggle")
  end)
end
