local in_vscode = require("util").in_vscode
if in_vscode() then
  return
end
local add, later = MiniDeps.add, MiniDeps.later
local map = require("util").map

later(function()
  add({
    source = "neovim/nvim-lspconfig",
    depends = {
      "b0o/SchemaStore.nvim",
      "mfussenegger/nvim-jdtls",
      "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    },
  })
  local lsp = require("lsp")
  local util = require("util.lsp")
  for server_name, config in pairs(lsp) do
    if config.setup ~= nil and type(config.setup) == "function" then
      config.setup()
    else
      local final_config = util.make_lspconfig(config)
      require("lspconfig")[server_name].setup(final_config)
    end
  end
  local sonarlint_path = os.getenv("SONARLINT_PATH")
  if sonarlint_path ~= nil then
    require("sonarlint").setup({
      server = {
        cmd = {
          "java",
          "-jar",
          "-Xms128m",
          "-Xmx512m",
          sonarlint_path .. "/server/sonarlint-ls.jar",
          -- Ensure that sonarlint-language-server uses stdio channel
          "-stdio",
          "-analyzers",
          -- paths to the analyzers you need, using those for python and java in this example
          sonarlint_path .. "/analyzers/sonarpython.jar",
          sonarlint_path .. "/analyzers/sonarcfamily.jar",
          sonarlint_path .. "/analyzers/sonarjava.jar",
        },
        settings = require("lsp.sonarlint-language-server").settings,
      },
      filetypes = {
        -- Tested and working
        "python",
        "cpp",
        -- Requires nvim-jdtls, otherwise an error message will be printed
        "java",
      },
    })
  end
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Lsp code action")
  map("n", "<leader>cl", vim.lsp.codelens.run, "Run codelens")
  map("n", "<leader>cL", vim.lsp.codelens.refresh, "Refresh codelens")
  map("n", "<leader>k", vim.lsp.buf.signature_help, "Lsp signature help")
  map("n", "<leader>cw", vim.lsp.buf.add_workspace_folder, "Lsp add workspace folder")
  map("n", "<leader>cW", vim.lsp.buf.remove_workspace_folder, "Lsp remove workspace folder")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Lsp rename")
  map("n", "<leader>Q", vim.diagnostic.setloclist, "Lsp diagnostic location list")
  map("n", "<leader>cI", vim.lsp.buf.incoming_calls, "Lsp incoming calls")
  map("n", "<leader>ch", vim.lsp.buf.outgoing_calls, "Lsp outgoing calls")
  map("n", "<leader>cH",
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
    end,
    "Lsp inlay hint toggle")
  map("n", "<leader>cf", function()
      vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    "Lsp list workspace folder")
end)
