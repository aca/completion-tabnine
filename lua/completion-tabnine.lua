local completion = require'completion-tabnine.source'

local M = {}

function M.init()
  completion.register()
  vim.g.loaded_completion_tabnine = true
end

return M
