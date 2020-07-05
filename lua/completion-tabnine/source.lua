local M = {}
local api = vim.api
local luajob = require 'luajob'
-- local match = require 'completion.matching'

M.counter = 0
M.callback = false
M.getCallback = function()
  return M.callback
end

M.items = {}
M.job = luajob:new({
    cmd = vim.fn["expand"]("<sfile>:p:h:h") .. "/TabNine",
    on_stderr = function(err, data)
      if err then
        print('TabNine: ', err)
      elseif data then
        print('TabNine: ', data)
      end
    end,
    on_exit = function(code, signal)
      print('TabNine: job exited', code, signal)
    end,
    on_stdout = function(err, data)
      if err then
        print('error:', err)
      elseif data then

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
        local response = vim.fn.json_decode(data)
        for _, result in ipairs(response.results) do
          table.insert(M.items, result.new_prefix)
        end
        M.callback = true

      end
    end
  })

M.job.start()


M.triggerFunction = function(_, opt)
  local cursor=api.nvim_win_get_cursor(0)
  local lines_before = api.nvim_buf_get_lines(0, 0, cursor[1]-1, true)
  local cur_line = api.nvim_get_current_line()
  local cur_line_before = string.sub( cur_line, 0, cursor[2])
  table.insert(lines_before, cur_line_before)
  local before = vim.fn.join(lines_before, "\n")

  local cur_line_after = string.sub( cur_line, cursor[2]+1) -- include current character
  local lines_after = api.nvim_buf_get_lines(0, cursor[1], -1, true)
  table.insert(lines_after, 1, cur_line_after)
  local after = vim.fn.join(lines_after, "\n")

  local req = {}
  req.version = "2.0.0"
  req.request = {
    Autocomplete = {
      before = before,
      after = after,
      region_includes_beginning = true,
      region_includes_end = true,
      max_num_results = 10,
      filename = vim.fn["expand"]("%:p")
    }
  }

  M.job.send(vim.fn.json_encode(req) .. "\n")
end


M.getCompletionItems = function(prefix)
  local complete_items = {}
  for _, item in ipairs(M.items) do
    if item ~= "^" .. prefix then
      table.insert(complete_items, {
          word = item,
          kind = 'tabnine',
          -- score = score,
          -- icase = 1,
          -- dup = 1,
          -- empty = 1,
          icase = 1,
          dup = 0,
          empty = 0,
        })
    end
  end
  return complete_items
end

function M.register()
  if require'completion' then
    require'completion'.addCompletionSource('tabnine', {
        trigger = M.triggerFunction,
        callback = M.getCallback,
        item = M.getCompletionItems,
      })
  end
end

return M
