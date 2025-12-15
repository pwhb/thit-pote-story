local dialogue_box = {}

local function utf8_safe_sub(str, start_char, end_char)
    local pos = 1
    local current_char = 1
    local start_byte = 1
    local end_byte = #str

    while pos <= #str and current_char < start_char do
        local c = str:byte(pos)
        if c < 128 then
            pos = pos + 1
        elseif c < 224 then
            pos = pos + 2
        elseif c < 240 then
            pos = pos + 3
        else
            pos = pos + 4
        end
        current_char = current_char + 1
    end
    start_byte = pos

    while pos <= #str and current_char <= end_char do
        local c = str:byte(pos)
        if c < 128 then
            pos = pos + 1
        elseif c < 224 then
            pos = pos + 2
        elseif c < 240 then
            pos = pos + 3
        else
            pos = pos + 4
        end
        current_char = current_char + 1
    end
    end_byte = pos - 1

    return str:sub(start_byte, end_byte)
end

function dialogue_box.draw(dialogue, speaker)
    local text = dialogue.text
    if not text then
        return
    end

    local w, h = love.graphics.getDimensions()

    local box_x, box_y = 20, h - 120
    local box_width, box_height = w - 40, 100
    local corner_radius = 8
    local padding = 20

    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", box_x + 4, box_y + 4, box_width, box_height, corner_radius, corner_radius)

    love.graphics.setColor(0.1, 0.1, 0.15, 0.4)
    love.graphics.rectangle("fill", box_x, box_y, box_width, box_height, corner_radius, corner_radius)

    if speaker then
        love.graphics.setColor(0.8, 0.8, 1, 1)
        love.graphics.setFont(love.graphics.newFont(18))
        love.graphics.printf(speaker, box_x + padding, box_y - padding, box_width - padding * 2, "left")
    end

    local text_y = box_y + padding
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(16))

    local visible_text = utf8_safe_sub(dialogue.text, 1, dialogue.displayed_chars)

    if dialogue.type == "narration" then
        visible_text = "> " .. visible_text
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(16))

    love.graphics.printf(visible_text, box_x + padding, box_y + padding, box_width - padding * 2, "left")

end

return dialogue_box
