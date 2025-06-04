local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

vim.api.nvim_set_keymap("n", "<leader>w", ":bp|bd#<CR>", { noremap = true, silent = true })

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- require("lint").linters_by_ft = {
--   python = { "pylint" },
-- }

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- https://github.com/williamboman/mason-lspconfig.nvim
require("mason-lspconfig").setup({
  ensure_installed = { "ruff", "pylsp", "tflint" },
})

-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
require("lspconfig").pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        black = {
          enabled = true,
        },
        isort = {
          enabled = true,
        },
        -- pylint is only works from a binary but will throw errors for imports
        pylint = {
          enabled = false,
          executable = "pylint",
        },
        ruff = {
          enabled = true,
        },
        pyflakes = {
          enabled = false,
        },
        pycodestyle = {
          enabled = false,
        },
        jedi_completion = {
          fuzzy = true,
        },
      },
    },
  },
})
-- https://github.com/neovim/nvim-lspconfig
-- require("lspconfig").jedi_language_server.setup({})

-- used for notebook molton plugin
local quarto = require("quarto")
quarto.setup({
  lspFeatures = {
    -- NOTE: put whatever languages you want here:
    languages = { "r", "python", "rust" },
    chunks = "all",
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  keymap = {
    -- NOTE: setup your own keymaps:
    hover = "H",
    definition = "gd",
    rename = "<leader>rn",
    references = "gr",
    format = "<leader>gf",
  },
  codeRunner = {
    enabled = true,
    default_method = "molten",
  },
})

-- usd for notebook parsing (molten)
require("jupytext").setup({
  style = "markdown",
  output_extension = "md",
  force_ft = "markdown",
})

require("nvim-treesitter.configs").setup({
  -- ... other ts config
  textobjects = {
    move = {
      enable = true,
      set_jumps = false, -- you can change this if you want.
      goto_next_start = {
        --- ... other keymaps
        ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
      },
      goto_previous_start = {
        --- ... other keymaps
        ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
      },
    },
    select = {
      enable = true,
      lookahead = true, -- you can change this if you want
      keymaps = {
        --- ... other keymaps
        ["ib"] = { query = "@code_cell.inner", desc = "in block" },
        ["ab"] = { query = "@code_cell.outer", desc = "around block" },
      },
    },
    swap = { -- Swap only works with code blocks that are under the same
      -- markdown header
      enable = true,
      swap_next = {
        --- ... other keymap
        ["<leader>sbl"] = "@code_cell.outer",
      },
      swap_previous = {
        --- ... other keymap
        ["<leader>sbh"] = "@code_cell.outer",
      },
    },
  },
})

-- smartyank
require("smartyank").setup({
  highlight = {
    enabled = true, -- highlight yanked text
    higroup = "IncSearch", -- highlight group of yanked text
    timeout = 2000, -- timeout for clearing the highlight
  },
  clipboard = {
    enabled = true,
  },
  tmux = {
    enabled = true,
    -- remove `-w` to disable copy to host client's clipboard
    cmd = { "tmux", "set-buffer", "-w" },
  },
  osc52 = {
    enabled = true,
    -- escseq = 'tmux',     -- use tmux escape sequence, only enable if
    -- you're using tmux and have issues (see #4)
    ssh_only = true, -- false to OSC52 yank also in local sessions
    silent = false, -- true to disable the "n chars copied" echo
    echo_hl = "Directory", -- highlight group of the OSC52 echo message
  },
  -- By default copy is only triggered by "intentional yanks" where the
  -- user initiated a `y` motion (e.g. `yy`, `yiw`, etc). Set to `false`
  -- if you wish to copy indiscriminately:
  -- validate_yank = false,
  --
  -- For advanced customization set to a lua function returning a boolean
  -- for example, the default condition is:
  -- validate_yank = function() return vim.v.operator == "y" end,
})
