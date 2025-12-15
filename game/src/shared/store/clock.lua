local time_periods = require("data.static.time_periods")
local Clock = {
    twilight_index = 1,
    default = 2,
    day_range = {2, 6}
}

function Clock:new(index)
    index = index or self.default
    local obj = {
        current_period = index
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Clock:get()
    local time_of_day = "night"
    if self.current_period >= self.day_range[1] and self.current_period <= self.day_range[2] then
        time_of_day = "day"
    end
    return {
        name = time_periods[self.current_period].name,
        time_of_day = time_of_day
    }
end

function Clock:advance(is_twilight)
    is_twilight = is_twilight or false
    self.current_period = self.current_period + 1
    if self.current_period > #time_periods then
        self.current_period = is_twilight and self.twilight_index or self.default
    end
end

return Clock
