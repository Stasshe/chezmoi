return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"

    opts.winbar = nil
    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      status.component.mode(),
      status.component.git_branch(),
      status.component.file_info(),
      status.component.git_diff(),
      status.component.diagnostics(),
      status.component.fill(),
      status.component.lsp(),
      status.component.virtual_env(),
      status.component.treesitter(),
      status.component.cmd_info {
        surround = {
          separator = "right",
          color = "cmd_info_bg",
          condition = function()
            local condition = require "astroui.status.condition"
            return condition.is_hlsearch() or condition.is_macro_recording() or condition.is_statusline_showcmd()
          end,
        },
      },
      status.component.nav(),
      status.component.mode { surround = { separator = "right" } },
    }
  end,
}
