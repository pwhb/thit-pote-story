local dialogue_box = require("src.shared.ui.components.dialogue_box")
local GameState = require("src.shared.store.game_state")
local Settings = require("src.shared.store.settings")
local HUD = {}

function HUD.draw(dialogue)
    local lang = Settings.lang
    local w, h = love.graphics.getDimensions()
    local font = love.graphics.newFont(16)
    local day = string.format("Day %d", GameState.day)
    local period = GameState.clock:get().name[lang]
    local location = GameState.location
    local emotion = love.graphics.newText(font, GameState.emotion:get())
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(day, 10, 10, 360)
    love.graphics.printf(period, 10, 30, 360)
    love.graphics.printf(location, 10, 50, 360)

    love.graphics.draw(emotion, w - emotion:getWidth() - 10, 10)

    local bar_width = 100
    local fill = bar_width * (GameState.energy / 100)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", w - bar_width - 10, 30, bar_width, 10)
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", w - bar_width - 10, 30, fill, 10)

    if dialogue then
        dialogue_box.draw(dialogue, dialogue.speaker)
    end
end

return HUD
