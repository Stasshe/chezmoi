local function selene_configured(path)
  return #vim.fs.find("selene.toml", { path = path, upward = true, type = "file" }) > 0
end

return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = function(_, opts)
    opts.linters_by_ft = {
      lua = { "selene" },
    }
    opts.linters = opts.linters or {}
    opts.linters.selene = {
      condition = function(ctx) return selene_configured(ctx.filename) end,
    }
  end,
}
