local store = require("src.shared.store.init")
local Factory = require("src.shared.utils.factory")

--- @class GameState
--- @field public day number
--- @field public location string
--- @field public clock any
--- @field public emotion any
--- @field public energy any
--- @field public character_book any
local GameState = Factory.encapsulated({
    day = 1,
    location = "Judson",
    clock = store.Clock:new(1),
    emotion = store.Emotion:new(0, 0),
    energy = 100,
    character_book = store.character_book:new()
}, function(private)
    return {
        set_lang = function(v)
            private.lang = v
        end
    }
end)

return GameState
