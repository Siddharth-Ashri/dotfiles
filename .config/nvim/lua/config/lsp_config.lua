require("neodev").setup({})
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "tsserver", "biome", "ast_grep" },
})

local on_attach = function(_, _)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
  vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
end

local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})
lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
lspconfig.biome.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
lspconfig.ast_grep.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
