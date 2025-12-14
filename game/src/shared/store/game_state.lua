local store = require("src.shared.store.init")

local game_state = {}

function game_state:new()
    local obj = {
        day = 1,
        location = "Judson",
        clock = store.clock:new(1),
        emotion = store.emotion:new(0, 0),
        energy = 100,
        dialogue_engine = store.dialogue_engine:new(),
        character_book = store.character_book:new()
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function game_state:get()
    return self
end

return game_state
