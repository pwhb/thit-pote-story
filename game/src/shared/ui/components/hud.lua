local dialogue_box = require("src.shared.ui.components.dialogue_box")
local hud = {}

function hud.draw(game_state)
    local font = love.graphics.newFont(16)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(string.format("Day %d • %s • %s", game_state.day, game_state.period.name,
        game_state.location), 10, 10, 360)
    local bar_width = 200
    local fill = bar_width * (game_state.energy / 100)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 10, 30, bar_width, 10)
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", 10, 30, fill, 10)

    if game_state.current_dialogue then
        dialogue_box.draw(game_state.current_dialogue)
    end
end

return hud
