local scripts = require("data.static.scripts.init")
local Settings = require("src.shared.store.settings")
local M = require("src.shared.utils.common")
local Factory = require("src.shared.utils.factory")

local function prepare_dialogue_node(node_data)
    if not node_data then
        return nil
    end

    local new_dialogue = M.shallow_merge({
        displayed_chars = 0,
        accumulated_time = 0
    }, node_data)

    return new_dialogue
end

--- @class DialogueEngine
--- @field public current_index number
--- @field public current_script any
--- @field public current_dialogue any
--- @field public load_script fun(code: string)
--- @field public next fun()
--- @field public update fun(dt: number)
local DialogueEngine = Factory.encapsulated({
    current_index = nil,
    current_script = nil,
    current_dialogue = nil
}, function(private)
    return {
        load_script = function(code)
            local current_script = scripts[code]
            local nodes = {}
            private.current_index = current_script["nodes"][1]["id"]
            for _, value in ipairs(current_script["nodes"]) do
                nodes[value["id"]] = value
            end
            private.current_script = M.shallow_merge(current_script, {
                nodes = nodes
            })
            private.current_dialogue = prepare_dialogue_node(private.current_script["nodes"][private.current_index])
            return private.current_script
        end,
        next = function()
            local next_node = private.current_dialogue["next_node"]
            private.current_index = next_node and next_node or private.current_index + 1
            private.current_dialogue = prepare_dialogue_node(private.current_script["nodes"][private.current_index])
            if private.current_dialogue.type == "command" then
                return private.current_dialogue
            end
        end,
        update = function(dt)
            local typewriter_speed = Settings.typewriter_speed
            local dialogue = private.current_dialogue
            if dialogue and dialogue.text and dialogue.displayed_chars < #dialogue.text then
                dialogue.accumulated_time = dialogue.accumulated_time + dt
                local target_chars = math.floor(dialogue.accumulated_time / typewriter_speed)
                dialogue.displayed_chars = math.min(target_chars, #dialogue.text)
            end
        end
    }
end)

return DialogueEngine
