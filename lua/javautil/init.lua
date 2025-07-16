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



local function find_in_file(path, pattern)
      local match_line = nil

      for linenr, line in ipairs(vim.fn.readfile(Path:new(root_dir, path).absolute())) do
            if line:find(pattern, 1, true) then
                  match_line = linenr
                  break
            end
      end

      return match_line
end

local function jump_to_file_line(filepath, linenr)
      vim.cmd("edit " .. filepath)
      vim.api.nvim.win_set_cursor(0, { linenr, 0 } )
end

function M.jump_to_mapper_xml()
      local current_file = vim.fn.expand("%:t")
      local method = vim.fn.expand("<cword>")

      local mapper_name = current_file:gsub(".java", ".xml")
      local search_dir = "src/main/resources"

      Job:new({
            command = "rg",
            args = { 'id="' .. method .. '"', "--glob", "**/" .. mapper_name, search_dir},
            on_exit = function(j, return_val)
                  local result = j:result()
                  vim.schedule(function()
                        if #result == 1 then
                              local filepath = result[1]
                              local linenr = find_in_file(filepath, 'id="' .. method .. '"') or 1
                              jump_to_file_line(filepath, linenr)
                        elseif #result > 1 then
                              require("telescope.builtin").grep_string({
                                    search = 'id="' .. method .. '"',
                                    search_dirs = { search_dir },
                                    prompt_title = "Mybatis XML Jump",
                              })
                        else
                              vim.notify("not found")
                        end
                  end)
            end,
      }):start()
end


return M
