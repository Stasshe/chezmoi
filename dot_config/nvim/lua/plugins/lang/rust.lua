--- Fallback so `dap.continue()` works without mason-nvim-dap (rustaceanvim adds configs asynchronously).
local function setup_rust_dap_fallback()
  local dap = require "dap"
  local function exepath_or_binary(binary)
    local exe_path = vim.fn.exepath(binary)
    return #exe_path > 0 and exe_path or binary
  end

  if vim.fn.executable "codelldb" == 1 then
    dap.adapters.codelldb = dap.adapters.codelldb
      or {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = exepath_or_binary "codelldb",
          args = { "--port", "${port}" },
        },
      }
  elseif vim.fn.executable "lldb-dap" == 1 or vim.fn.executable "lldb-vscode" == 1 then
    local cmd = vim.fn.executable "lldb-dap" == 1 and "lldb-dap" or "lldb-vscode"
    dap.adapters.lldb = dap.adapters.lldb
      or {
        type = "executable",
        command = exepath_or_binary(cmd),
        name = "lldb",
      }
  else
    return
  end

  local typ = dap.adapters.codelldb and "codelldb" or "lldb"
  dap.configurations.rust = dap.configurations.rust or {}
  for _, c in ipairs(dap.configurations.rust) do
    if c.__rust_dap_fallback then return end
  end

  local cfg = {
    __rust_dap_fallback = true,
    name = "Rust: pick debug binary",
    type = typ,
    request = "launch",
    stopOnEntry = false,
    program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file") end,
    cwd = "${workspaceFolder}",
  }
  if typ == "codelldb" then
    cfg.sourceLanguages = { "rust" }
  else
    cfg.console = "integratedTerminal"
  end
  table.insert(dap.configurations.rust, cfg)
end

return {
  {
    "AstroNvim/astrocore",
    optional = true,
    ---@type AstroCoreOpts
    opts = {
      treesitter = { ensure_installed = { "rust" } },
    },
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      handlers = { rust_analyzer = false }, -- disable setup of `rust_analyzer`
      ---@diagnostic disable: missing-fields
      config = {
        rust_analyzer = {
          filetypes = { "rust" },
          settings = {
            ["rust-analyzer"] = {
              files = {
                exclude = {
                  ".direnv",
                  ".git",
                  "target",
                },
              },
              check = {
                command = "clippy",
                extraArgs = {
                  "--no-deps",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        on_attach = function(...) require("astrolsp").on_attach(...) end,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = vim.fn.has "nvim-0.11" == 1 and "^6" or "^5",
    ft = "rust",
    opts = function()
      -- DAP: rustaceanvim default adapter — `codelldb` or `lldb-dap` / `lldb-vscode` on PATH (e.g. mise).
      local server = {
        on_attach = function(client, bufnr)
          -- vim.keymap.set("n", "<leader>la", function()
          --   vim.cmd.RustLsp "codeAction"
          -- end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set(
            "n",
            "<leader>d",
            function() vim.cmd.RustLsp "debuggables" end,
            { desc = "Rust Debuggables", buffer = bufnr }
          )

          if client.server_capabilities.codeLensProvider then
            local group_name = "codelens_" .. bufnr
            vim.api.nvim_create_augroup(group_name, { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              group = group_name,
              callback = function() vim.lsp.codelens.enable(true, { bufnr = bufnr }) end,
              buffer = bufnr,
            })
          end
        end,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            check = {
              command = "clippy",
              extraArgs = {
                "--no-deps",
              },
            },
            checkOnSave = true,
            diagnostics = {
              enable = true,
              disabled = { "inactive-code" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            inlayHints = {
              enable = false,
            },
            lens = {
              enable = true,
              implementations = {
                enable = true,
              },
              references = {
                adt = {
                  enable = true,
                },
                enumVariant = {
                  enable = true,
                },
                method = {
                  enable = true,
                },
                trait = {
                  enable = true,
                },
              },
              run = {
                enable = true,
              },
            },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
            },
          },
        },
      }

      return {
        server = server,
        dap = { load_rust_types = true },
        tools = { enable_clippy = false },
      }
    end,
    config = function(_, opts) vim.g.rustaceanvim = opts end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    ft = "rust",
    config = setup_rust_dap_fallback,
  },
}
