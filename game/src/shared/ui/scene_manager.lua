local hud = require("src.shared.ui.components.hud")

local scene_manager = {
    current_scene_name = nil,
    current_scene = nil,
    scenes = {},
    scene_stack = {},
    current_game_state = nil
}

function scene_manager:push(scene_name)
    table.insert(self.scene_stack, self.current_scene_name)
    self:switch_to(scene_name)
end

function scene_manager:pop()
    if #self.scene_stack == 0 then
        self:switch_to("main_menu")
        return
    end

    local previous_scene = table.remove(self.scene_stack)
    self:switch_to(previous_scene)
end

function scene_manager:switch_to(scene_name)
    if self.current_scene and self.current_scene.exit then
        self.current_scene:exit()
    end

    local new_scene = self.scenes[scene_name]
    if not new_scene then
        error(string.format("Scene %s does not exist", scene_name))
    end

    self.current_scene = new_scene
    self.current_scene_name = scene_name
    if self.current_scene and self.current_scene.enter then
        self.current_scene:enter()
    end
end

function scene_manager:register(name, scene_module)
    self.scenes[name] = scene_module
end

function scene_manager:update(dt)
    if self.current_scene and self.current_scene.update then
        self.current_scene:update(dt)
    end
end

function scene_manager:draw()
    -- Draw the underlying scene (the one BELOW the pause menu)
    if #self.scene_stack > 0 then
        local previous_scene = self.scenes[self.scene_stack[#self.scene_stack]]
        if previous_scene and previous_scene.draw then
            previous_scene:draw()
        end
    end

    -- Draw the current scene (pause menu) on top
    if self.current_scene and self.current_scene.draw then
        self.current_scene:draw()
    end
    if (self.current_scene_name ~= "main_menu" and self.current_scene_name ~= "pause_menu" and self.current_scene_name ~=
        "load_menu") then
        hud.draw(self.current_game_state)
    end
end

function scene_manager:keypressed(key)
    if self.current_scene and self.current_scene.keypressed then
        self.current_scene:keypressed(key)
    end
end

function scene_manager:resize(w, h)
    if self.current_scene and self.current_scene.resize then
        self.current_scene:resize(w, h)
    end
end

return scene_manager
