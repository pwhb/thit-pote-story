local dialogue_box = {}

function dialogue_box.draw(dialogue)
    love.graphics.setColor(1, 1, 1)
    local w, h = love.graphics.getDimensions()
    if dialogue.text then
        love.graphics.print(dialogue.text, 20, h - 40)
    end

    if dialogue.speaker then
        love.graphics.print(dialogue.speaker, 20, h - 70)
    end
end

return dialogue_box
