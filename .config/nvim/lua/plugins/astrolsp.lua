---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      autoformat = true,
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
      signature_help = false,
    },
    formatting = {
      format_on_save = {
        enabled = true,
      },
      disabled = {},
      timeout_ms = 1000,
      filter = function(client)
        if vim.bo.filetype == "c" then return client.name == "null-ls" end
        return true
      end,
    },
    servers = {
      "zls",
      "m68k",
    },
    config = {
      -- ["*"] = { capabilities = {} }, -- modify default LSP client settings such as capabilities
      m68k = {
        filetypes = { "m68k" },
        cmd = {
          "m68k-lsp-server",
          "--stdio",
        },
      },
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--header-insertion-decorators",
          "--malloc-trim",
          "--pch-storage=memory",
        },
        capabilities = {
          offsetEncoding = "utf-8",
        },
      },
    },
    handlers = {
      -- a function with the key `*` modifies the default handler, functions takes the server name as the parameter
      -- ["*"] = function(server) vim.lsp.enable(server) end

      -- the key is the server that is being setup with `vim.lsp.config`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
    },
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.enable(true, { bufnr = args.buf }) end
          end,
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    on_attach = function(client, bufnr) end,
  },
}
