local M = {}

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

            if text:find('[vV][aA][rR][cC][hH][aA][rR]') then
                  vim.api.nvim_command(tostring(i) .. " s/varchar/String/")
            elseif text:find('[cC][hH][aA][rR]') then
                  vim.api.nvim_command(tostring(i) .. " s/char/String/")
            elseif text:find('[bB][iI][gG][iI][nN][tT]') then
                  vim.api.nvim_command(tostring(i) .. " s/bigint/long/")
            elseif text:find('[tT][iI][nN][yY][iI][nN][tT]') then
                  vim.api.nvim_command(tostring(i) .. " s/tinyint/int/")
            elseif text:find('[dD][eE][cC][iI][mM][aA][lL]') then
                  vim.api.nvim_command(tostring(i) .. " s/decimal/float/")
            elseif text:find('[dD][aA][tT][eE][tT][iI][mM][eE]') then
                  vim.api.nvim_command(tostring(i) .. " s/datetime/String/")
            elseif text:find('[tT][iI][mM][eE][sS][Tt][aA][mM][pP]') then
                  vim.api.nvim_command(tostring(i) .. " s/timestamp/String/")
            end

            vim.api.nvim_command('normal! $b')
            local cursor = vim.api.nvim_win_get_cursor(0)

            text = vim.api.nvim_get_current_line()

            local startCol, endCol = text:find("[%a%d_]+", cursor[2]+1)
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
            local position = text:find('%(')

            if position == nil then
                  vim.api.nvim_command("normal! 0f`;eld$a ")
            else
                  vim.api.nvim_command("normal! 0f(d$a ")
            end


            if text:find('[vV][aA][rR][cC][hH][aA][rR]') then
                  vim.api.nvim_command(tostring(i) .. " s/varchar/rs.getString(/")
            elseif text:find('[cC][hH][aA][rR]') then
                  vim.api.nvim_command(tostring(i) .. " s/char/rs.getString(/")
            elseif text:find('[bB][iI][gG][iI][nN][tT]') then
                  vim.api.nvim_command(tostring(i) .. " s/bigint/rs.getLong(/")
            elseif text:find('[tT][iI][nN][yY][iI][nN][tT]') then
                  vim.api.nvim_command(tostring(i) .. " s/tinyint/rs.getInt(/")
            elseif text:find('[iI][nN][tT]') then
                  vim.api.nvim_command(tostring(i) .. " s/int/rs.getInt(")
            elseif text:find('[dD][eE][cC][iI][mM][aA][lL]') then
                  vim.api.nvim_command(tostring(i) .. " s/decimal/float/rs.getFloat(/")
            elseif text:find('[dD][aA][tT][eE][tT][iI][mM][eE]') then
                  vim.api.nvim_command(tostring(i) .. " s/datetime/rs.getString(/")
            elseif text:find('[tT][iI][mM][eE]') then
                  vim.api.nvim_command(tostring(i) .. " s/time/rs.getString(/")
            end

            local cursor = vim.api.nvim_win_get_cursor(0)

            text = vim.api.nvim_get_current_line()

            vim.api.nvim_command("normal! 0f`w")


            local startCol, endCol = text:find("[%a_]+", cursor[2]+1)
            local variableName = startCol and text:sub(startCol, endCol):lower()

            while true do
                  if text:find('_') then
                        vim.api.nvim_command('normal! 0f_x~')
                        text = vim.api.nvim_get_current_line()
                  else
                        break
                  end
            end

            vim.api.nvim_command('normal! A' .. variableName)
            vim.api.nvim_command('normal! ^xf`r(lxf r"ea"));')
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


return M
