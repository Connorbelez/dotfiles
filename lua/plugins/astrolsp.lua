if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  config = function()
    local lspconfig = require "lspconfig"
    local lsp = vim.lsp

    local servers = {
      clangd = {},
      sourcekit = {
        root_dir = lspconfig.util.root_pattern(".git", "Package.swift", "compile_commands.json"),
      },
      lspconfig.rust_analyzer.setup {},
    }

    for server, setup in pairs(servers) do
      lspconfig[server].setup(setup)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP Actions",
      callback = function(args)
        -- Once we've attached, configure the keybindings
        local wk = require "which-key"
        wk.register({
          K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP hover info" },
          gd = { "<cmd>lua vim.lsp.buf.definition()<cr>", "LSP go to definition" },
          gD = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "LSP go to declaration" },
          gi = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "LSP go to implementation" },
          gr = { "<cmd>lua vim.lsp.buf.references()<cr>", "LSP list references" },
          gs = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "LSP signature help" },
          gn = { "<cmd>lua vim.lsp.buf.rename()<cr>", "LSP rename" },
          ["[g"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Go to previous diagnostic" },
          ["g]"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Go to next diagnostic" },
        }, {
          mode = "n",
          -- buffer = true,
          silent = true,
        })
      end,
    })
  end,
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      autoformat = true, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      clangd = {},
      sourcekit = {
        -- root_dir = lspconfig.util.root_pattern(
        --   '.git',
        --   'Package.swift',
        --   'compile_commands.json'
        -- ),
      },
      -- lspconfig.rust_analyzer.setup {}
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_document_highlight = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/documentHighlight",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        -- gD = {
        --   function() vim.lsp.buf.declaration() end,
        --   desc = "Declaration of current symbol",
        --   cond = "textDocument/declaration",
        -- },
        -- ["<Leader>uY"] = {
        --   function() require("astrolsp.toggles").buffer_semantic_tokens() end,
        --   desc = "Toggle LSP semantic highlight (buffer)",
        --   cond = function(client) return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens end,
        -- },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
