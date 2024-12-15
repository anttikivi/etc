-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

---@class anttikivi.util.root
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(m)
    return m.get()
  end,
})

---@class AKRoot
---@field paths string[]
---@field spec AKRootSpec

---@alias AKRootFn fun(buf: number): (string|string[])

---@alias AKRootSpec string|string[]|AKRootFn

---@type AKRootSpec[]
M.spec = { "lsp", { ".git", "lua" }, "cwd" }

---@type table<number, string>
M.cache = {}

M.detectors = {}

function M.detectors.cwd()
  return { vim.uv.cwd() }
end

function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then
    return {}
  end
  local roots = {} ---@type string[]
  local clients = AK.lsp.get_clients({ bufnr = buf })
  clients = vim.tbl_filter(function(client)
    return not vim.tbl_contains(vim.g.root_lsp_ignore or {}, client.name)
  end, clients)
  for _, client in pairs(clients) do
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_to_fname(ws.uri)
    end
    if client.root_dir then
      roots[#roots + 1] = client.root_dir
    end
  end
  return vim.tbl_filter(function(path)
    path = AK.norm(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.uv.cwd()
  local pattern = vim.fs.find(function(name)
    ---@diagnostic disable-next-line: param-type-mismatch
    for _, p in ipairs(patterns) do
      if name == p then
        return true
      end
      if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then
        return true
      end
    end
    return false
  end, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.bufpath(buf)
  return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

function M.cwd()
  return M.realpath(vim.uv.cwd()) or ""
end

function M.realpath(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.uv.fs_realpath(path) or path
  return AK.norm(path)
end

---@param opts? { buf?: number, spec?: AKRootSpec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec
    or type(vim.g.root_spec) == "table" and vim.g.root_spec
    or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0)
      and vim.api.nvim_get_current_buf()
    or opts.buf

  local ret = {} ---@type AKRoot[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        roots[#roots + 1] = pp
      end
    end
    table.sort(roots, function(a, b)
      return #a > #b
    end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then
        break
      end
    end
  end
  return ret
end

function M.info()
  local spec = type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec

  local roots = M.detect({ all = true })
  local lines = {} ---@type string[]
  local first = true
  for _, root in ipairs(roots) do
    for _, path in ipairs(root.paths) do
      lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
        first and "x" or " ",
        path,
        ---@diagnostic disable-next-line: param-type-mismatch
        type(root.spec) == "table" and table.concat(root.spec, ", ")
          or root.spec
      )
      first = false
    end
  end
  lines[#lines + 1] = "```lua"
  lines[#lines + 1] = "vim.g.root_spec = " .. vim.inspect(spec)
  lines[#lines + 1] = "```"
  AK.info(lines, { title = "AK Roots" })
  return roots[1] and roots[1].paths[1] or vim.uv.cwd()
end

---@param spec AKRootSpec
---@return AKRootFn
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("AKRoot", function()
    AK.root.info()
  end, { desc = "AK roots for the current buffer" })

  -- FIX: doesn't properly clear cache in neo-tree `set_root` (which should happen presumably on `DirChanged`),
  -- probably because the event is triggered in the neo-tree buffer, therefore add `BufEnter`
  -- Maybe this is too frequent on `BufEnter` and something else should be done instead??
  vim.api.nvim_create_autocmd(
    { "LspAttach", "BufWritePost", "DirChanged", "BufEnter" },
    {
      group = vim.api.nvim_create_augroup("ak_root_cache", { clear = true }),
      callback = function(event)
        M.cache[event.buf] = nil
      end,
    }
  )
end

return M
