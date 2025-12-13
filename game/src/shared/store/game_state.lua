local emotion = require("src.shared.store.emotion")
local clock = require("src.shared.store.clock")
local game_state = {}

function game_state:new()
    local obj = {
        day = 1,
        location = "Judson",
        clock = clock:new(),
        emotion = emotion:new(0, 0),
        energy = 100
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
    -- self.day = 1
    -- clock:new()
    -- self.period = clock:get_time()
    -- self.location = "Judson"
    -- self.energy = 100
    -- self.current_dialogue = nil
end

function game_state:get()
    return self
end

return game_state
