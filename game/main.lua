local scene_manager = require("src.shared.ui.scene_manager")
local game_state = require("src.shared.store.game_state")

scene_manager:register("main_menu", require("src.shared.ui.scenes.main_menu"))
scene_manager:register("vn", require("src.vn.game"))
scene_manager:register("rpg", require("src.rpg.game"))
scene_manager:register("settings", require("src.shared.ui.scenes.settings"))
scene_manager:register("pause_menu", require("src.shared.ui.scenes.pause_menu"))

function love.load()
    -- scene_manager.current_game_state = game_state:new()
    scene_manager:switch_to("main_menu")
end

function love.update(dt)
    scene_manager:update(dt)
end

function love.draw()
    scene_manager:draw()
end

function love.keypressed(key)
    scene_manager:keypressed(key)
end

function love.resize(w, h)
    scene_manager:resize(w, h)
end
