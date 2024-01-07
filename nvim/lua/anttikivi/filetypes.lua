local M = {}

function M.add_filetypes()
  vim.filetype.add {
    filename = {
      [".ansible-lint"] = "yaml",
      -- TODO: Find a better way to set Ansible playbooks' file type.
      ["local.yml"] = "yaml.ansible",
    },
    patterns = {
      ["**/tasks/*.yml"] = "yaml.ansible",
    },
  }
end

return M
