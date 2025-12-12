local clock_states = require("data.static.clock_states")
local clock = {}

function clock:new(index)
    self.current_period = index and index or 2
end

function clock:get_time()
    return clock_states[self.current_period]
end

return clock
