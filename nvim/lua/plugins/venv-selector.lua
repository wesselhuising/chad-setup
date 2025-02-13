return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    -- "mfussenegger/nvim-dap",
    -- "mfussenegger/nvim-dap-python", --optional
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  lazy = false,
  branch = "regexp", -- This is the regexp branch, use this for the new version
  config = function()
    require("venv-selector").setup()
  end,
  keys = {
    { ",v", "<cmd>VenvSelect<cr>" },
  },
}
-- return {
--   "linux-cultist/venv-selector.nvim",
--   branch = "regexp", -- Use this branch for the new version
--   cmd = "VenvSelect",
--   enabled = function()
--     return LazyVim.has("telescope.nvim")
--   end,
--   opts = {
--     settings = {
--       options = {
--         notify_user_on_venv_activation = true,
--       },
--     },
--   },
--   --  Call config for python files and load the cached venv automatically
--   ft = "python",
--   keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
-- }
