local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require "null-ls"
local builtins = null_ls.builtins

local opts = {
  sources = {
    builtins.diagnostics.mypy,
    builtins.diagnostics.pylint,
    builtins.formatting.black,
    builtins.formatting.isort,
    builtins.formatting.stylua,
    builtins.formatting.prettier.with {
      filetypes = { "html", "markdown", "css" },
    },
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}

return opts
