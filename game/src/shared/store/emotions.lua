local emotions = {}

function emotions.new(Valence, Arousal)
    return {
        Valence = Valence,
        Arousal = Arousal
    }
end

return emotions
