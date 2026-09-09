-- Customize None-ls sources
local null_ls = require "null-ls"
local helpers = require "null-ls.helpers"

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    opts.debug = true

    local verible_verilog_format = {
      name = "verible_verilog_format",
      filetypes = { "verilog", "systemverilog" },
      method = null_ls.methods.FORMATTING,
      generator = helpers.formatter_factory {
        command = "verible-verilog-format",
        args = function(params)
          local args = {}

          local targets = vim.fs.find(
            { ".verible_format", ".git" },
            { path = vim.fs.dirname(params.bufname), upward = true, limit = 1 }
          )
          if #targets > 0 then
            local match = targets[1]
            if match:match "%.verible_format" then
              table.insert(args, "--flagfile")
              table.insert(args, match)
            end
          end

          table.insert(args, "--stdin_name")
          table.insert(args, params.bufname)
          table.insert(args, "-")
          return args
        end,
        to_stdin = true,
      },
    }

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier,
      verible_verilog_format,

      null_ls.builtins.formatting.clang_format.with {
        extra_args = function(params)
          if params.bufname:match "%.inc$" then return { "--assume-filename=file.c" } end
          return {}
        end,
      },
    })
  end,
}
