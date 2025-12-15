local Factory = require("src.shared.utils.factory")

--- @class Settings
--- @field public lang string
--- @field public audio boolean
--- @field public typewriter_speed number
--- @field public set_lang fun(self: Settings,lang: string)
--- @field public set_audio fun(self: Settings,enabled: boolean)
--- @field public set_typewriter_speed fun(self: Settings,speed: number)
local Settings = Factory.encapsulated({
    lang = "en",
    audio = true,
    typewriter_speed = 0.03
}, function(private)
    return {
        set_lang = function(v)
            private.lang = v
        end,
        set_audio = function(v)
            private.audio = v
        end,
        set_typewriter_speed = function(v)
            private.typewriter_speed = v
        end
    }
end)

return Settings
