local scripts = require("data.static.scripts.init")
local dialogue_engine = {
    current_index = nil,
    current_script = nil
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
    return self.current_script
end

function dialogue_engine:set(dialogue)
    self.current_dialogue = dialogue
end

function dialogue_engine:get()
    return self.current_script and self.current_script["nodes"][self.current_index] or ""
end

function dialogue_engine:next()
    local next_node = self.current_script["nodes"][self.current_index]["next_node"]
    self.current_index = next_node and next_node or self.current_index + 1
end

function dialogue_engine:clear()
    self.current_dialogue = nil
end

return dialogue_engine
