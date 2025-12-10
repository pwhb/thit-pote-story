local scene_manager = require("src.shared.ui.scene_manager")
local game_state = require("src.shared.game_state")

scene_manager:register("main_menu", require("src.shared.ui.scenes.main_menu"))
scene_manager:register("vn", require("src.vn.game"))
scene_manager:register("rpg", require("src.rpg.game"))
scene_manager:register("settings", require("src.shared.ui.scenes.settings"))

function love.load()
    game_state:reset()
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
