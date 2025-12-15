local Settings = {}

function Settings:new()
    local obj = {
        lang = "en",
        audio = true
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Settings:get()
    return self
end

return Settings
