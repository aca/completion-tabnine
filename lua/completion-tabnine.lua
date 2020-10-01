local M = {}
local vim = vim
local api = vim.api
local fn = vim.fn
local completion = require 'completion'
-- local match = require 'completion.matching'
--
local function json_decode(data)
  local status, result = pcall(vim.fn.json_decode, data)
  if status then
    return result
  else
    return nil, result
  end
end

M.callback = false
M.getCallback = function() return M.callback end

local function sortByDetail(a,b)
  local a_score = a.detail ~= nil and tonumber(string.sub(a.detail,0, -2)) or 0
  local b_score = b.detail ~= nil and tonumber(string.sub(b.detail,0, -2)) or 0
  return a_score >  b_score
end

M.items = {}

M.triggerFunction = function()
  if M.job == 0 then
    return
  end
  M.callback = false

  local max_lines = vim.g.completion_tabnine_max_lines
  local cursor=api.nvim_win_get_cursor(0)

  local cur_line = api.nvim_get_current_line()
  local cur_line_before = string.sub(cur_line, 0, cursor[2])
  local cur_line_after = string.sub(cur_line, cursor[2]+1) -- include current character

  local region_includes_beginning = false
  local region_includes_end = false
  if cursor[1] - max_lines <= 1 then region_includes_beginning = true end
  if cursor[1] + max_lines >= fn['line']('$') then region_includes_end = true end

  local lines_before = api.nvim_buf_get_lines(0, cursor[1] - max_lines , cursor[1]-1, false)
  table.insert(lines_before, cur_line_before)
  local before = fn.join(lines_before, "\n")

  local lines_after = api.nvim_buf_get_lines(0, cursor[1], cursor[1] + max_lines, false)
  table.insert(lines_after, 1, cur_line_after)
  local after = fn.join(lines_after, "\n")

  local req = {}
  req.version = "2.0.0"
  req.request = {
    Autocomplete = {
      before = before,
      after = after,
      region_includes_beginning = region_includes_beginning,
      region_includes_end = region_includes_end,
      max_num_results = vim.g.completion_tabnine_max_num_results,
      filename = fn["expand"]("%:p")
    }
  }

  fn.chansend(M.job, fn.json_encode(req) .. "\n")
end

M.getCompletionItems = function()
  local complete_items = {}
  for _, item in ipairs(M.items) do
    table.insert(complete_items, {
      word = item,
      kind = 'tabnine',
      icase = 1,
      dup = 0,
      empty = 0,
    })
  end
  return complete_items
end

M.job = 0

function M.register()
  M.job = fn.jobstart({ vim.g.completion_tabnine_tabnine_path }, {
  -- on_stderr = function(_, data, _)
  --   print('TabNine:', "unknown error")
  -- end,
  on_exit = function(_, code)
    if code ~= 143 then print('TabNine: exit', code) end
  end,
  on_stdout = function(_, data, _)

      -- {
      --   "old_prefix": "wo",
      --   "results": [
      --     {
      --       "new_prefix": "world",
      --       "old_suffix": "",
      --       "new_suffix": "",
      --       "detail": "64%"
      --     }
      --   ],
      --   "user_message": [],
      --   "docs": []
      -- }

      M.items = {}
      local response = json_decode(data)
      if response == nil then
        -- print('TabNine: json decode error')
        return
      end
      local results = response.results
      if results == nil then
        return
      end

      if vim.g.completion_tabnine_sort_by_details == 1 then
        table.sort(results, sortByDetail)
      end

      for _, result in ipairs(results) do
        table.insert(M.items, result.new_prefix)
      end
      M.callback = true
  end
  })

  completion.addCompletionSource('tabnine', {
    trigger = M.triggerFunction,
    callback = M.getCallback,
    item = M.getCompletionItems,
  })
end

return M
