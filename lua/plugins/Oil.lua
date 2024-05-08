


return {
  "stevearc/oil.nvim",
    event = "VeryLazy",
    lazy = true,
  opts = {},
  enabled = true,
  cmd = "Oil",
  keys = {
    { "<leader>O", function() require("oil").open() end, desc = "Open folder in Oil" },
  },
}
