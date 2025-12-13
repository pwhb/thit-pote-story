local emotion_states = require("data.static.emotion_states")
local emotion = {}

function emotion:new(valence, arousal)
    local obj = {
        state = {
            Valence = valence,
            Arousal = arousal
        }
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function emotion:get()
    local current = self.state
    local distances = {}

    for name, state in pairs(emotion_states) do
        local dv = current.Valence - state.Valence
        local da = current.Arousal - state.Arousal
        local dist = dv * dv + da * da
        table.insert(distances, {
            name = name,
            dist = dist
        })
    end

    table.sort(distances, function(a, b)
        return a.dist < b.dist
    end)

    local nearest = distances[1]
    local second = distances[2]

    if second and (second.dist - nearest.dist) <= 100 then
        return string.format("%s & %s", nearest.name, second.name)
    else
        return nearest.name
    end
end

return emotion
