local scripts = require("data.static.scripts.init")
local Settings = require("src.shared.store.settings")
local M = require("src.shared.utils.common")
local DialogueEngine = {
    current_index = nil,
    current_script = nil,
    current_dialogue = nil
}

function DialogueEngine:new(dialogue)
    dialogue = dialogue or ""
    local obj = {
        current_dialogue = dialogue
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

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

function DialogueEngine:load_script(code)
    self.current_script = scripts[code]
    self.current_index = 1
    self.current_dialogue = prepare_dialogue_node(self.current_script["nodes"][self.current_index])
    return self.current_script
end

function DialogueEngine:set(dialogue)
    self.current_dialogue = dialogue
end

function DialogueEngine:get()
    return self.current_dialogue
end

function DialogueEngine:next()
    local next_node = self.current_script["nodes"][self.current_index]["next_node"]
    self.current_index = next_node and next_node or self.current_index + 1
    self.current_dialogue = prepare_dialogue_node(self.current_script["nodes"][self.current_index])
end

function DialogueEngine:update(dt)
    local typewriter_speed = Settings.typewriter_speed
    local dialogue = self.current_dialogue
    if dialogue and dialogue.text and dialogue.displayed_chars < #dialogue.text then
        dialogue.accumulated_time = dialogue.accumulated_time + dt
        local target_chars = math.floor(dialogue.accumulated_time / typewriter_speed)
        dialogue.displayed_chars = math.min(target_chars, #dialogue.text)
    end
end

function DialogueEngine:clear()
    self.current_dialogue = nil
end

return DialogueEngine
