
return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
        "BufReadPre path/to/my-vault/**.md", "BufNewFile path/to/my-vault/**.md"
    },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim"

        -- see below for full list of optional dependencies 👇
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Technical/"
            }, {
                name = "work",
                path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/COMP"
            }
        }

        -- see below for full list of options 👇
    }
}
