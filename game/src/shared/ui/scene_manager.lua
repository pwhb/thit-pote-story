local hud = require("src.shared.ui.components.hud")
local game_state = require("src.shared.game_state")

local scene_manager = {
    current_scene_name = nil,
    current_scene = nil,
    scenes = {}
}

function scene_manager:switch_to(scene_name)
    if self.current_scene and self.current_scene.exit then
        self.current_scene.exit()
    end

    local new_scene = self.scenes[scene_name]
    if not new_scene then
        error(string.format("Scene %s does not exist", scene_name))
    end

    self.current_scene = new_scene
    self.current_scene_name = scene_name
    if self.current_scene and self.current_scene.enter then
        self.current_scene.enter()
    end
end

function scene_manager:register(name, scene_module)
    self.scenes[name] = scene_module
end

function scene_manager:update(dt)
    if self.current_scene and self.current_scene.update then
        self.current_scene.update(dt)
    end
end

function scene_manager:draw()
    if self.current_scene and self.current_scene.draw then
        self.current_scene.draw()
    end
    if not (self.current_scene_name == "main_menu") then
        hud.draw(game_state:get())
    end
end

function scene_manager:keypressed(key)
    if self.current_scene and self.current_scene.keypressed then
        self.current_scene.keypressed(key)
    end
end

return scene_manager
