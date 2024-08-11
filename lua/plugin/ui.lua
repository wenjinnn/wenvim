local in_vscode = require("util").in_vscode
if in_vscode() then
  return
end
local now, later = MiniDeps.now, MiniDeps.later
local map = vim.keymap.set
now(function()
  local starter = require("mini.starter")
  starter.setup({
    items = {
      starter.sections.sessions(5, true),
      starter.sections.recent_files(5, true, true),
      starter.sections.recent_files(5, false, true),
      {
        name = "Agenda",
        action = function()
          require("util").feedkey("<leader>oa", "")
        end,
        section = "Org",
      },
      {
        name = "Capture",
        action = function()
          require("util").feedkey("<leader>oc", "")
        end,
        section = "Org",
      },
      starter.sections.builtin_actions(),
    },
  })
end)
now(function()
  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()
end)

later(function()
  require("mini.notify").setup()
  MiniIcons.mock_nvim_web_devicons()
  map("n", "<leader>N", MiniNotify.show_history, { desc = "Notify history" }
  )
end)

now(function()
  require("mini.statusline").setup()
  require("mini.tabline").setup()
end)
later(function()
  local hipatterns = require("mini.hipatterns")
  local hi_words = require("mini.extra").gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
      fix = hi_words({ "FIX", "Fix", "fix" }, "MiniHipatternsFixme"),
      hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
      todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
      note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
      done = hi_words({ "DONE", "Done", "done" }, "MiniHipatternsNote"),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)
later(function()
  local miniclue = require("mini.clue")
  local z_post_keys = { zl = "z", zh = "z", zL = "z", zH = "z" }
  local clue_z_keys = miniclue.gen_clues.z()
  for _, v in ipairs(clue_z_keys) do
    for key, postkeys in pairs(z_post_keys) do
      if v.keys == key then
        v.postkeys = postkeys
      end
    end
  end
  require("mini.clue").setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      -- Built-in completion
      { mode = "i", keys = "<C-x>" },
      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      -- Window commands
      { mode = "n", keys = "<C-w>" },
      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      -- mini.surround
      { mode = "n", keys = "s" },
      -- mini.bracketed
      { mode = "n", keys = "]" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "\\" },
      -- Operator-pending mode key
      { mode = "o", keys = "a" },
      { mode = "o", keys = "i" },
    },
    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      clue_z_keys,
    },
  })
end)
