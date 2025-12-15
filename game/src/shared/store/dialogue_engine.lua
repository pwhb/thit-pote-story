local scripts = require("data.static.scripts.init")
local dialogue_engine = {
    current_index = nil,
    current_script = nil,
    current_dialogue = nil
}

function dialogue_engine:new(dialogue)
    dialogue = dialogue or ""
    local obj = {
        current_dialogue = dialogue
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function dialogue_engine:load_script(code)
    self.current_script = scripts[code]
    self.current_index = 1
    self.current_dialogue = self.current_script and self.current_script["nodes"][self.current_index]
    self.current_dialogue.displayed_chars = 0 -- How many chars are visible
    self.current_dialogue.start_time = love.timer.getTime() -- When typing started
    return self.current_script
end

function dialogue_engine:set(dialogue)
    self.current_dialogue = dialogue
end

function dialogue_engine:get()
    return self.current_dialogue
end

function dialogue_engine:next()
    local next_node = self.current_script["nodes"][self.current_index]["next_node"]
    self.current_index = next_node and next_node or self.current_index + 1
    self.current_dialogue = self.current_script and self.current_script["nodes"][self.current_index]
    self.current_dialogue.displayed_chars = 0 -- How many chars are visible
    self.current_dialogue.start_time = love.timer.getTime() -- When typing started
end

function dialogue_engine:update(speed)
    if self.current_dialogue and self.current_dialogue.text and self.current_dialogue.displayed_chars <
        #self.current_dialogue.text then
        local elapsed = love.timer.getTime() - self.current_dialogue.start_time
        local target_chars = math.floor(elapsed / speed)
        self.current_dialogue.displayed_chars = math.min(target_chars, #self.current_dialogue.text)
    end
end

function dialogue_engine:clear()
    self.current_dialogue = nil
end

return dialogue_engine
