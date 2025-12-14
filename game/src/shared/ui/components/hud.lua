local dialogue_box = require("src.shared.ui.components.dialogue_box")
local hud = {}

function hud.draw(game_state, settings)
    local w, h = love.graphics.getDimensions()
    local font = love.graphics.newFont(16)

    local day = string.format("Day %d", game_state.day)
    local period = game_state.clock:get().name[settings.lang]
    local location = game_state.location
    local emotion = love.graphics.newText(font, game_state.emotion:get())

    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(day, 10, 10, 360)
    love.graphics.printf(period, 10, 30, 360)
    love.graphics.printf(location, 10, 50, 360)

    love.graphics.draw(emotion, w - emotion:getWidth() - 10, 10)

    local bar_width = 100
    local fill = bar_width * (game_state.energy / 100)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", w - bar_width - 10, 30, bar_width, 10)
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", w - bar_width - 10, 30, fill, 10)

    if game_state.dialogue_engine then
        dialogue_box.draw(game_state.dialogue_engine:get())
    end
end

return hud
