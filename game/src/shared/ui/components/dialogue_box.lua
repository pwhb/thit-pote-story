local dialogue_box = {}

function dialogue_box.draw(dialogue)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(dialogue, 10, 10, 200)
end

return dialogue_box
