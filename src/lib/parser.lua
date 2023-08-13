--
-- parser.lua 2023.08.12
--
-- Copyright (c) 2023 Seedking
--
-- MIT License
--

local parser = {_version = "0.1.0"}

local function split (str, char)
    local str_clean = string.gsub(str, "%s+","")
    local where_char = string.find(str_clean, char)
    return string.sub(str_clean, 1, where_char-1), string.sub(str_clean, where_char + 1, string.len(str_clean))
end

parser.toTable = function (file, table)
    -- 直接将解析结果输入参数中的table
    -- 空
    -- #注释
    -- [table]
    -- key = value
    local current_key = nil
    for line in file:lines() do
        if (string.gsub(line,"%s+","") == "") then
            goto continue
        elseif (string.find(line,"#")) then
            goto continue
        elseif (string.find(line, "%[")) then
            table[string.match(line, "%w+")] = {}
            current_key = table[string.match(line, "%w+")]
            goto continue
        elseif (string.find(line,"=")) then
            local strA,strB = split(line, "=")
            current_key[strA] = strB
            goto continue
        end
        ::continue::
    end
end

parser.toTableFrom = function(file, table, mode, ...)
    -- 行号    linenum L
    -- 关键字  keyword K
    local current_key = nil
    local storage = ...
    local counter = 1
    local line_str = ""
    local running = false

    local switch = {
        L = function()
            if (counter < storage) then
                counter = counter + 1
                return false
            end
            return true
        end,
        K = function()
            if (not((string.find(line_str, storage) ~= nil) and (string.find(line_str, "%[") ~= nil))) then
                return false
            end
            return true
        end
    }

    for line in file:lines() do
        ::start::
        line_str = line
        if (not(running)) then
            if (switch[mode]()) then
                running = true
                goto start
            end
        else
            if (string.gsub(line,"%s+","") == "") then
                goto continue
            elseif (string.find(line,"#")) then
                goto continue
            elseif (string.find(line, "%[")) then
                table[string.match(line, "%w+")] = {}
                current_key = table[string.match(line, "%w+")]
                goto continue
            elseif (string.find(line,"=")) then
                local strA,strB = split(line, "=")
                current_key[strA] = strB
                goto continue
            end
        end
        ::continue::
    end
end

parser.toFile = function (file, table)
    for s,t in pairs(table) do
        file:write("[", s, "]\n")
        for k,y in pairs(t) do
            file:write(k, " = ", y, "\n")
        end
        file:write("\n")
    end
end

return parser