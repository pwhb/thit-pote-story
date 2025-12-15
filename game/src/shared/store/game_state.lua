local store = require("src.shared.store.init")

local GameState = {}

function GameState:new()
    local obj = {
        day = 1,
        location = "Judson",
        clock = store.Clock:new(1),
        emotion = store.Emotion:new(0, 0),
        energy = 100,
        character_book = store.character_book:new()
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function GameState:get()
    return self
end

return GameState
