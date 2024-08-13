local later = MiniDeps.later
local map = require("util").map

-- git
later(function()
  require("mini.git").setup()
  map({ "n", "x" }, "<leader>ga", MiniGit.show_at_cursor, "Git show at cursor")
  map({ "n", "v" }, "<leader>gh", MiniGit.show_range_history, "Git show range history")
  map({ "n", "v" }, "<leader>gd", MiniGit.show_diff_source, "Git show diff source")
end)

later(function()
  require("mini.diff").setup()
  map("n", "<leader>go", MiniDiff.toggle_overlay, "Git toggle overlay")
end)
