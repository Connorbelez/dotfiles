local prefix = "<leader><leader>"
local term_string = vim.fn.exists "$TMUX" == 1 and "tmux" or "term"
local maps = { n = {} }
local icon = vim.g.icons_enabled and "󱡀 " or ""
maps.n[prefix] = { desc = icon .. "Harpoon" }
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    { prefix .. "a", function() require("harpoon"):list():add() end,  desc = "Add file" },
    {
      prefix .. "e",
      function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
      desc = "Toggle quick menu",
    },
    {
      "<C-x>",
      function()
        vim.ui.input({ prompt = "Harpoon mark index: " }, function(input)
          local num = tonumber(input)
          if num then require("harpoon"):list():select(num) end
        end)
      end,
      desc = "Goto index of mark",
    },
    { "<C-p>",       function() require("harpoon"):list():prev() end,    desc = "Goto previous mark" },
    { "<C-n>",       function() require("harpoon"):list():next() end,    desc = "Goto next mark" },
    { "<leader><leader>1",   function() require("harpoon"):list():select(1) end, desc = "Goto mark 1" },
    { "<leader>2",   function() require("harpoon"):list():select(2) end, desc = "Goto mark 2" },
    { "<leader>3",   function() require("harpoon"):list():select(3) end, desc = "Goto mark 3" },
    { "<leader>4",   function() require("harpoon"):list():select(4) end, desc = "Goto mark 4" },
    { prefix .. "m", "<cmd>Telescope harpoon marks<CR>",                 desc = "Show marks in Telescope" },
    {
      prefix .. "t",
    },
  }
}

