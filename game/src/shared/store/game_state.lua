local emotions = require("src.shared.store.emotions")
local clock = require("src.shared.store.clock")
local game_state = {}

-- local init_state = {
--     day = 1,
--     period = "Morning",
--     location = "Home",
--     energy = 100,
--     emotion = emotions.new(0, 0)
-- }

function game_state:reset()
    self.day = 1

    clock:new(1)

    self.period = clock:get_time()
    self.location = "Judson"
    self.energy = 100
    self.current_dialogue = nil
end

function game_state:get()
    return self
end

return game_state
