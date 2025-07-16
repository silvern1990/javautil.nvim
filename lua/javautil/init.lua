local M = {}

local root_dir = require("jdtls.setup").find_root({"mvnw", "gradlew", "pom.xml", "build.gradle"})

local Job = require("plenary.job")
local Path = require("plenary.path")

--
-- INSERT 쿼리에서 컬럼 명 영역을 선택후 실행하면 클립보드에 #{value} 형태로 포맷팅 하여 저장한다.
--
function M.columnToMybatisValue()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)

      local currentBuffer = vim.api.nvim_get_current_buf()

      local startSelection = vim.api.nvim_buf_get_mark(currentBuffer, "<")[1]
      local endSelection = vim.api.nvim_buf_get_mark(currentBuffer, ">")[1]
      local lineCnt = endSelection-startSelection

      if lineCnt == 0 then
            lineCnt = 1
      end

      vim.api.nvim_command("normal! " .. tostring(startSelection) .. "G")

      local mybatis_values = ""

      for i=startSelection, endSelection do
            local text = vim.api.nvim_get_current_line()

            for word in text:gmatch("%S+") do
                  local mybatisValue, comma = word:gsub(',', '', 1)
                  mybatisValue = mybatisValue:gsub('_%a', function(match)
                        return match:sub(2):upper()
                  end)

                  mybatisValue = '#{' .. mybatisValue .. '}'
                  if comma == 1 then
                        mybatisValue = mybatisValue .. ', '
                  else
                        mybatisValue = mybatisValue .. '\n'
                  end

                  mybatis_values = mybatis_values .. mybatisValue
            end

            if i < endSelection then
                  vim.api.nvim_command("normal! j")
            end
      end

      vim.fn.setreg('+', mybatis_values)
end

function M.mysqlToValueObject()

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)

      local currentBuffer = vim.api.nvim_get_current_buf()


      local startSelection = vim.api.nvim_buf_get_mark(currentBuffer, "<")[1]
      local endSelection = vim.api.nvim_buf_get_mark(currentBuffer, ">")[1]
      local lineCnt = endSelection-startSelection

      if lineCnt == 0 then
            lineCnt = 1
      end

      vim.api.nvim_command("normal! " .. tostring(startSelection) .. "G")

      for i=startSelection, endSelection do

            local text = vim.api.nvim_get_current_line()
            local position = text:find('%(')

            if position == nil or text:find('current_timestamp') then
                  vim.api.nvim_command("normal! 0f`;eld$a ")
            else
                  vim.api.nvim_command("normal! 0f(d$a ")
            end

            vim.api.nvim_command("normal! 0f`lvex$pA;")
            vim.api.nvim_command("normal! ^3xiprivate ")
            vim.api.nvim_command("normal! w")


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
            local before_text = line:sub(1, start_col-1)
            local after_text = line:sub(end_col + 1)

            local l_word = word:lower()
            if l_word == 'varchar' 
                  or l_word == 'char' 
                  or l_word == 'text' 
                  or l_word == 'datetime'
                  or l_word == 'timestamp'
                  or l_word == 'time'
            then
                  word = word:gsub(word, 'String')
            elseif word:lower() == 'bigint' then
                  word = word:gsub(word, 'long')
            elseif word:lower() == 'tinyint' then
                  word = word:gsub(word, 'int')
            elseif word:lower() == 'decimal' then
                  word = word:gsub(word, 'float')
            end

            local new_text = before_text .. ' ' .. word .. ' ' .. after_text

            vim.fn.setline(vim.api.nvim_win_get_cursor(0)[1], new_text)

            vim.api.nvim_command('normal! $b')
            local cursor = vim.api.nvim_win_get_cursor(0)

            text = vim.api.nvim_get_current_line()

            local startCol, endCol = text:find("[%w_]+", cursor[2]+1)
            local variableName = startCol and text:sub(startCol, endCol):lower()


            vim.api.nvim_command("normal! $bvexi" .. variableName)


            while true do
                  if text:find('_') then
                        vim.api.nvim_command('normal! 0f_x~')
                        text = vim.api.nvim_get_current_line()
                  else
                        break
                  end
            end

            if i < endSelection then
                  vim.api.nvim_command("normal! j")
            end
      end
end


function M.mysqlToObjectMapper()

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)

      local currentBuffer = vim.api.nvim_get_current_buf()


      local startSelection = vim.api.nvim_buf_get_mark(currentBuffer, "<")[1]
      local endSelection = vim.api.nvim_buf_get_mark(currentBuffer, ">")[1]
      local lineCnt = endSelection-startSelection

      if lineCnt == 0 then
            lineCnt = 1
      end

      vim.api.nvim_command("normal! " .. tostring(startSelection) .. "G")

      for i=startSelection, endSelection do

            local text = vim.api.nvim_get_current_line()
            local variable_name = text:match('`.*`'):gsub('`', '')
            local position = text:find('%(')


            if position == nil or text:find('current_timestamp') then
                  vim.api.nvim_command("normal! 0f`;eld$a")
            else
                  vim.api.nvim_command("normal! 0f(d$a")
            end

            vim.api.nvim_command("normal! b")

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
            local before_text = line:sub(1, start_col-1)
            local after_text = line:sub(end_col + 1)

            local l_word = word:lower()

            if l_word == 'varchar' or
                  l_word == 'char' or 
                  l_word == 'datetime' or
                  l_word == 'time' or
                  l_word == 'text' or
                  l_word == 'timestamp'
            then
                  word = word:gsub(word, 'rs.getString("')
            elseif l_word == 'bigint' then
                  word = word:gsub(word, 'rs.getLong("')
            elseif l_word == 'tinyint' or l_word == 'int' then
                  word = word:gsub(word, 'rs.getInt("')
            elseif l_word == 'decimal' then
                  word = word:gsub(word, 'rs.getFloat("')
            end


            local new_text = before_text:lower() .. ' ' .. word .. after_text

            vim.fn.setline(vim.api.nvim_win_get_cursor(0)[1], new_text)

            text = vim.api.nvim_get_current_line()

            vim.api.nvim_command("normal! 0f`w")

            while true do
                  if text:find('_') then
                        vim.api.nvim_command('normal! 0f_x~')
                        text = vim.api.nvim_get_current_line()
                  else
                        break
                  end
            end

            vim.api.nvim_command('normal! A' .. variable_name)
            vim.api.nvim_command('normal! ^xf`r(lxA"));')
            vim.api.nvim_command('normal! ^~^iobj.set')

            if i < endSelection then
                  vim.api.nvim_command("normal! j")
            end
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


-- search mapper.method call
local function extract_mapper_call()
      local line = vim.api.nvim_get_current_line()
      local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1

      for obj, method, start_idx in line:gmatch("([%w_]+)%.([%w_]+)%s*%(") do
            local match_col = line:find(obj .. "." .. method, 1, true)
            vim.notify(obj .. "." .. method)
            if match_col and cursor_col >= match_col and cursor_col <= match_col + #obj + #method + 1 then
                  return obj, method
            end
      end

      return nil, nil
end

-- search mapper type in current buffer
local function find_mapper_type(var_name)
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      for _, line in ipairs(lines) do
            local type_, var = line:match("([%w_]+)%s+([%w_]+)%s*;")
            if type_ and var == var_name then
                  return type_
            end

            local type2, var2 = line:match("([%w_]+)%s+([%w_]+)%s*=")
            if type2 and var2 == var_name then
                  return type2
            end
      end
      return nil
end

local function jump_to_xml(mapper_type, method_id)
      local file_name = mapper_type .. ".xml"
      local search_dir = "src/main/resources"

      Job:new({
            command = "rg",
            args = { 'id="' .. method_id .. '"', "--files-with-matches", "--glob", "**/" .. file_name, search_dir }, 
            on_exit = function(j, code)
                  local result = j:result()
                  vim.schedule(function()
                        if #result == 0 then
                              vim.notify("definition not found")
                              return
                        end

                        local filepath = result[1]
                        local lines = vim.fn.readfile(filepath)
                        for i, line in ipairs(lines) do
                              if line:find('id="' .. method_id .. '"', 1, true) then
                                    vim.cmd("edit " .. filepath)
                                    vim.api.nvim_win_set_cursor(0, { i, 0 })
                                    vim.cmd("normal! zz")
                                    return
                              end
                        end
                        vim.cmd("edit " .. filepath)
                        vim.api.nvim_win_set_cursor(0, { 1, 0 })
                  end)
            end
      }):start()
end

function M.jump_to_mapper_xml()
      local obj, method = extract_mapper_call()
      if not obj or not method then
            local current_file = vim.fn.expand("%:t")
            method = vim.fn.expand("<cword>")
            jump_to_xml(current_file:gsub("%.java", ""), method)
            return
      end

      local mapper_type = find_mapper_type(obj)
      if not mapper_type then
            print("mapper Type not found: " .. obj)
            return
      end

      jump_to_xml(mapper_type, method)
end



return M
