-- data/static/scenes/ch0_wakeup.lua
return {
    id = "001_opening",
    background = "dorm_room_day", -- key for time_of_day-aware asset loader
    time_of_day = "dawn",
    characters = {
        cassandra = {
            expression = "neutral", -- asset: cassandra/neutral.png
            position = "left"
        }
    },
    lines = {{
        speaker = "cassandra",
        text = "This memory is fragile. Hold it gently.",
        side_effects = {{
            type = "set_mood",
            valence = -10,
            arousal = 30
        }, {
            type = "unlock_scene",
            id = "cassandra_intro"
        }}
    }},
    choices = {{
        id = "ask_name",
        text = "Who are you?",
        next_scene = "cassandra_intro",
        requirements = {{
            type = "mood",
            valence_gt = -20
        } -- Only if not too distressed
        }
    }, {
        id = "ignore",
        text = "I need to get ready for class...",
        next_scene = "morning_routine"
    }}
}
