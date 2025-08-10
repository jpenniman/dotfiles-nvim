return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {}
  },
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  { 'akinsho/git-conflict.nvim', version = "*", config = true },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000,    -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end
  },
  -- {
  --   "TomDeneire/lsp-in-gutter.nvim",
  --   config = true
  -- },

  -- https://github.com/NvChad/NvChad/discussions/2193
  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = {
  --     completion = {
  --       autocomplete = false,
  --     },
  --   },
  -- },
  {
    "Hoffs/omnisharp-extended-lsp.nvim"
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "csharp-language-server",
        "omnisharp",
        "rust-analyzer",
        "xmlformatter",
        "stylua",
        "bicep-lsp",
        "html-lsp",
        "css-lsp",
        "eslint-lsp",
        "typescript-language-server",
        "csharpier",
        "prettier",
        "json-lsp"
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- ensure_installed = "all"
      ensure_installed = {
        "hyprlang",
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "c_sharp",
        "bicep"
      },
    },
  },
  -- {"akinsho/bufferline.nvim"},
  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {
      toggler = {
        ---Line-comment toggle keymap
        line = "gcc",
        ---Block-comment toggle keymap
        block = "gbc",
      },
    },
  },

  {
    -- Debug Framework
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require "configs.nvim-dap"
    end,
    event = "VeryLazy",
  },
  { "nvim-neotest/nvim-nio" },
  {
    -- UI for debugging
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require "configs.nvim-dap-ui"
    end,
  },
  {
    "kaiwalter/azure-functions.nvim",
    config = function()
      require("azure-functions").setup {
        compress_log = true,
      }
    end,
    lazy = false,
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },

  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" }
  },

  -- integrate into local ai
  {
    "David-Kunz/gen.nvim",
    lazy = false,
    opts = {
      apisecret =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVkMzBlNDllLWEzNGMtNDY1Yy04OTYzLTNiNTQ1MGM3N2E0OSJ9.rOuX3yIwioVWtwXQYlxF-DQ-LbLvkY2uTjQaKdzjr6w",
      model = "aya-expanse:8b", -- The default model to use.
      -- model = "deepseek-coder-v2", -- The default model to use.
      quit_map = "q",           -- set keymap for close the response window
      retry_map = "<c-r>",      -- set keymap to re-send the current prompt
      accept_map = "<c-cr>",    -- set keymap to replace the previous selection with the last result

      -- host = "owebui.ramboe.io",          -- The host running the Ollama service.
      -- port = "443",              -- The port on which the Ollama service is listening.

      host = "localhost",     -- The host running the Ollama service.
      port = "3000",          -- The port on which the Ollama service is listening.
      display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = true,     -- Shows the prompt submitted to Ollama.
      show_model = true,      -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false,  -- Never closes the window automatically.
      hidden = false,         -- Hide the generation window (if true, will implicitly set `prompt.replace = true`)
      -- init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      -- Function to initialize Ollama
      command = function(options)
        local body = { model = options.model, stream = true }

        return "curl --silent --no-buffer -X POST http://" ..
            options.host ..
            ":" ..
            options.port ..
            "/api/chat/completions -H 'Authorization: Bearer " ..
            options.apisecret .. "' -H 'Content-Type: application/json' -d $body"
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      debug = false -- Prints errors and the command which is run.
    }
  },

  {
    "nvim-neotest/neotest",
    requires = {
      {
        "Issafalcon/neotest-dotnet",
      }
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  },
  {
    "Issafalcon/neotest-dotnet",
    lazy = false,
    dependencies = {
      "nvim-neotest/neotest"
    }
  },
  { "smithbm2316/centerpad.nvim" }
  -- {
  --   "m4xshen/smartcolumn.nvim",
  --   opts = {}
  -- }
}
