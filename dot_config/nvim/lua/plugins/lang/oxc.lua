local function oxlint_conf_mentions_typescript(root_dir)
  local fn = vim.fs.joinpath(root_dir, ".oxlintrc.json")
  for line in io.lines(fn) do
    if line:find "typescript" then return true end
  end
  return false
end

return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      servers = {
        "oxfmt",
        "oxlint",
      },
      config = {
        oxlint = {
          cmd = { "oxlint", "--lsp" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" },
          root_markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" },
          workspace_required = true,
          on_attach = function(client, bufnr)
            vim.api.nvim_buf_create_user_command(
              bufnr,
              "LspOxlintFixAll",
              function()
                client:exec_cmd {
                  title = "Apply Oxlint automatic fixes",
                  command = "oxc.fixAll",
                  arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
                }
              end,
              {
                desc = "Apply Oxlint automatic fixes",
              }
            )
          end,
          before_init = function(init_params, config)
            local settings = config.settings or {}
            if settings.typeAware == nil and vim.fn.executable "tsgolint" == 1 then
              local ok, res = pcall(oxlint_conf_mentions_typescript, config.root_dir)
              if ok and res then settings = vim.tbl_extend("force", settings, { typeAware = true }) end
            end
            local init_options = config.init_options or {}
            init_options.settings = vim.tbl_extend("force", init_options.settings or {} --[[@as table]], settings)

            init_params.initializationOptions = init_options
          end,
        },
        oxfmt = {
          cmd = { "sh", "-c", [[NODE_PATH="$(npm root 2>/dev/null)" exec oxfmt --lsp]] },
          workspace_required = false,
          filetypes = {
            "javascript",
            "svelte",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "toml",
            "json",
            "jsonc",
            "json5",
            "yaml",
            "html",
            "vue",
            "handlebars",
            "css",
            "scss",
            "less",
            "graphql",
            "markdown",
          },
          root_dir = function(bufnr, on_dir)
            local lspconfig_util = require("lspconfig").util
            local fname = vim.api.nvim_buf_get_name(bufnr)

            -- Oxfmt resolves configuration by walking upward and using the nearest config file
            -- to the file being processed. We therefore compute the root directory by locating
            -- the closest `.oxfmtrc.json` / `.oxfmtrc.jsonc` / `oxfmt.config.ts` (or `package.json` fallback) above the buffer.
            local root_markers = lspconfig_util.insert_package_json(
              { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" },
              "oxfmt",
              fname
            )
            on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
          end,
        },
      },
    },
  },
}
