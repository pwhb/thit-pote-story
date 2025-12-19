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
    -- the less the faster -> normal 0.04, fast 0.02, faster 0.01, slow 0.08, slower 0.1
    typewriter_speed = 0.04
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
