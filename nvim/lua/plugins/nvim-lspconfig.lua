return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jedi_language_server = {
        enabled = false,
      },
      pylsp = {
        enabled = true,
      },
    },
  },
}
