local clock_states = require("data.static.clock_states")
local clock = {
    twilight_index = 1,
    default = 2,
    day_range = {2, 6}
}

function clock:new(index)
    index = index or self.default
    local obj = {
        current_period = index
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function clock:get()
    local time_of_day = "night"
    if self.current_period >= self.day_range[1] and self.current_period <= self.day_range[2] then
        time_of_day = "day"
    end
    return {
        name = clock_states[self.current_period].name,
        time_of_day = time_of_day
    }
end

function clock:advance(is_twilight)
    is_twilight = is_twilight or false
    self.current_period = self.current_period + 1
    if self.current_period > #clock_states then
        self.current_period = is_twilight and self.twilight_index or self.default
    end
end

return clock
