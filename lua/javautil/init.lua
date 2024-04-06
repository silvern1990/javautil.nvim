local M = {}


function M.mysqlToValueObject()
    local currentBuffer = vim.api.nvim_get_current_buf()

    local startSelection = vim.api.nvim_buf_get_mark(currentBuffer, "<")
    local endSelection = vim.api.nvim_buf_get_mark(currentBuffer, ">")


    for i = startSelection[1], endSelection[1] do
        local line = vim.fn.getline(i)
    end

end

function M.makeRequestMapping()
      -- Function to get the word under the cursor
      local line = vim.fn.getline('.')
      local col = vim.fn.col('.')
      local start_col = col
      local end_col = col

      -- Find the start of the word
      while start_col > 0 and line:sub(start_col, start_col):match('%w') do
          start_col = start_col - 1
      end

      -- Find the end of the word
      while end_col <= #line and line:sub(end_col, end_col):match('%w') do
          end_col = end_col + 1
      end

      -- Extract the word
      local word = line:sub(start_col + 1, end_col - 1)
      if #word < 1 then
        vim.notify("not found variable name under cursor", vim.log.levels.ERROR)
        return
      end

      vim.api.nvim_command("normal! dd") -- delete variable name line

      vim.cmd('Template var=' .. word .. ' mapping')
end

return M
