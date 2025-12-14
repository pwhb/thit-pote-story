local settings = {}

function settings:new()
    local obj = {
        lang = "en",
        audio = true
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function settings:get()
    return self
end

return settings
