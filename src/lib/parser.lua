--
-- parser.lua 2023.08.12
--
-- by Seedking
--

parser = {_version = "0.1.0"}
local dir_path = ""

local function split (str, char)
    local str_clean = string.gsub(str, "%s+","")
    local where_char = string.find(str_clean, char)
    return string.sub(str_clean, 1, where_char-1), string.sub(str_clean, where_char + 1, string.len(str_clean))
end

parser.setPath = function(path)
    dir_path = path
end

parser.toTable = function (file, table)
    -- 直接将解析结果输入参数中的table
    -- 空
    -- #注释
    -- [table]
    -- key = value
    current_key = nil
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

parser.toFile = function (file, table)
    
end

return parser