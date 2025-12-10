local game_state = {}

local init_state = {
    day = 1,
    period_name = "Morning",
    location = "Home",
    energy = 100,
    current_dialogue = nil
}

function game_state:reset()
    self.day = 1
    self.period_name = "Morning"
    self.location = "Home"
    self.energy = 100
    self.current_dialogue = nil
end

function game_state:get()
    return self
end

return game_state
