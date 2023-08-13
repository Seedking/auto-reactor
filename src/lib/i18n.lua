--
-- i18n.lua 2023.08.12
-- 
-- by Seedking
-- 

i18n = { _version = "0.1.0"}

local dir_path = ""
local dictionary = {}

i18n.setPath = function(path)
    dir_path = path
end

i18n.loadFile = function(language)
    dictionary = require(language)
end

return function (string)
    return dictionary[string]
end