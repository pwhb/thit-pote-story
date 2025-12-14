local dialogue_engine = {
    current_dialogue = nil
}

function dialogue_engine:new(dialogue)
    local obj = {
        current_dialogue = dialogue
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
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
