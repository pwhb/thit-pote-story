local characters = require("data.static.characters.init")
local character_book = {}

function character_book:new(index)
    index = index or self.default
    local obj = {
        ["PLAYER"] = {
            ["name_index"] = 1,
            ["name"] = {{
                ["en"] = "You",
                ["my"] = "You"
            }},
            ["avatar"] = {
                ["default"] = ""
            }
        }
    }
    for key, character in pairs(characters) do
        obj[key] = {
            name_index = 1,
            name = character["name"],
            avatar = character["avatar"]
        }
    end
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function character_book:get(code)
    return self[code]
end

function character_book:set(code, value)
    self[code] = value
end

return character_book
