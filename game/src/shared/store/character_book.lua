local characters = require("data.static.characters.init")
local CharacterBook = {}

function CharacterBook:new(index)
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

function CharacterBook:get(code)
    return self[code]
end

function CharacterBook:set(code, value)
    self[code] = value
end

return CharacterBook
