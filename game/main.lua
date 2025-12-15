local SceneManager = require("src.shared.ui.scene_manager")
SceneManager:register("main_menu", require("src.shared.ui.scenes.main_menu"))
SceneManager:register("vn", require("src.vn.game"))
SceneManager:register("rpg", require("src.rpg.game"))
SceneManager:register("settings", require("src.shared.ui.scenes.settings"))
SceneManager:register("pause_menu", require("src.shared.ui.scenes.pause_menu"))

function love.load()
    SceneManager:init()
    -- SceneManager.current_game_state = game_state:new()
    SceneManager:switch_to("main_menu")
end

function love.update(dt)
    SceneManager:update(dt)
end

function love.draw()
    SceneManager:draw()
end

function love.keypressed(key)
    SceneManager:keypressed(key)
end

function love.resize(w, h)
    SceneManager:resize(w, h)
end
