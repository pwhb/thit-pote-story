return {
    ["background"] = "MOON_LIT_JUDSON",
    ["image_assets"] = {"MOON_LIT_JUDSON"},
    ["audio_assets"] = {"FOREST_BIRDSONG_LOOPABLE", "FOOTSTEP_IN_GRAVEL"},
    ["characters"] = {"CASSANDRA"},
    ["background_sound_config"] = {
        ["volume"] = 0.01,
        ["loop"] = true
    },
    ["background_sound"] = "FOREST_BIRDSONG_LOOPABLE",
    ["time_of_day"] = "TWILIGHT",
    ["title"] = "Chapter 0",
    ["nodes"] = {{
        ["id"] = 1,
        ["text"] = "I find myself panting.",
        ["type"] = "monologue",
        ["next_node"] = 16
    }, {
        ["id"] = 2,
        ["text"] = "I feel like I just woke up from a bizarre nightmare. A very long one.",
        ["type"] = "monologue"
    }, {
        ["id"] = 3,
        ["text"] = "I can hear the birds singing outside.",
        ["type"] = "monologue"
    }, {
        ["id"] = 4,
        ["text"] = "Everything is ok, isn't it?",
        ["type"] = "monologue"
    }, {
        ["id"] = 5,
        ["text"] = "Why do I smell ashes, blood and tears in the air?",
        ["type"] = "monologue"
    }, {
        ["id"] = 6,
        ["text"] = "Why is it so unsettling?",
        ["type"] = "monologue"
    }, {
        ["id"] = 7,
        ["text"] = "I can't remember the dream well.",
        ["type"] = "monologue"
    }, {
        ["id"] = 8,
        ["text"] = "There was a global pandemic. We locked ourselves inside.",
        ["type"] = "monologue"
    }, {
        ["id"] = 9,
        ["text"] = "I remember saying goodbye to the beloved vaguely.",
        ["type"] = "monologue"
    }, {
        ["id"] = 10,
        ["text"] = "Was there a coup, afterwards? Was it just a nightmare?",
        ["type"] = "monologue"
    }, {
        ["id"] = 11,
        ["text"] = "Friends were locked inside—again. This time, against their will.",
        ["type"] = "monologue"
    }, {
        ["id"] = 12,
        ["text"] = "Is there an end to the demons?",
        ["type"] = "monologue"
    }, {
        ["id"] = 13,
        ["text"] = "It seemed like a movie. Friends and strangers joining hands against a common foe.",
        ["type"] = "monologue"
    }, {
        ["id"] = 14,
        ["text"] = "Except that there wasn't just one foe. It was us against them and I failed to understand who was us and who was them.",
        ["type"] = "monologue"
    }, {
        ["id"] = 15,
        ["text"] = "All the four horsemen of the apocalypse were there. I swear I saw them on their mighty mounts.",
        ["type"] = "monologue"
    }, {
        ["id"] = 16,
        ["text"] = "Did the world end? It did for someone everyday, didn't it?",
        ["type"] = "monologue"
    }, {
        ["id"] = 17,
        ["args"] = {"FOOTSTEP_IN_GRAVEL"},
        ["type"] = "command",
        ["func"] = "play_sound"
    }, {
        ["id"] = 18,
        ["text"] = "You see a weary girl walking towards you.",
        ["type"] = "narration"
    }, {
        ["id"] = 19,
        ["text"] = "Hello old friend. Your heart is heavy.",
        ["type"] = "dialogue",
        ["speaker"] = "CASSANDRA"
    }, {
        ["id"] = 20,
        ["text"] = "",
        ["type"] = "choices",
        ["speaker"] = "CASSANDRA",
        ["choices"] = {{
            ["text"] = "Who are you?",
            ["next_node"] = 18
        }}
    }, {
        ["id"] = 21,
        ["args"] = {"CASSANDRA", 1},
        ["type"] = "command",
        ["func"] = "update_name_index"
    }, {
        ["id"] = 22,
        ["text"] = "I'm in here.",
        ["type"] = "dialogue",
        ["speaker"] = "CASSANDRA"
    }, {
        ["id"] = 23,
        ["text"] = "Goodbye!",
        ["type"] = "dialogue",
        ["speaker"] = "CASSANDRA"
    }}

}
