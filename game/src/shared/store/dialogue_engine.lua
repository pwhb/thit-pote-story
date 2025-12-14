local scripts = require("data.static.scripts.init")
local dialogue_engine = {
    current_dialogue = nil,
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
end

function dialogue_engine:set(dialogue)
    self.current_dialogue = dialogue
end

function dialogue_engine:get()
    return self.current_dialogue
end

function dialogue_engine:clear()
    self.current_dialogue = nil
end

return dialogue_engine
