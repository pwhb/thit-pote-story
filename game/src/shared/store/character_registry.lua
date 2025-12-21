local Factory = require("src.shared.utils.factory")
local characters = require("data.static.characters.init")
--- @class CharacterRegistry
--- @field public new fun(self: CharacterRegistry): CharacterRegistry
--- @field public get_character fun(self: CharacterRegistry, code: string): string
local CharacterRegistry = Factory.class()

function CharacterRegistry:init()
    self.characters = {}
    for key, value in pairs(characters) do
        self.characters[key] = value
    end
end

function CharacterRegistry:get_character(code)
    return self.characters[code]
end

function CharacterRegistry:update_name_index(code, diff)
    self.characters[code].name_index = self.characters[code].name_index + diff
end

return CharacterRegistry

