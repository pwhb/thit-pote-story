local HUD = require("src.shared.ui.components.hud")
local GameState = require("src.shared.store.game_state")
local Settings = require("src.shared.store.settings")
local EventBus = require("src.shared.event_bus")
local DialogueEngine = require("src.shared.store.dialogue_engine")
local SceneManager = {
    is_loading = false,
    current_scene_name = nil,
    current_scene = nil,
    scenes = {},
    scene_stack = {},
    current_game_state = nil,
    current_settings = nil
}

function SceneManager:init()
    self.current_game_state = GameState:new()
    self.current_settings = Settings:new()
    self.dialogue_engine = DialogueEngine:new()

    EventBus:on("next_dialogue", function()
        if self.dialogue_engine.current_dialogue and self.dialogue_engine.current_dialogue.text and
            self.dialogue_engine.current_dialogue.displayed_chars < #self.dialogue_engine.current_dialogue.text then
            -- Skip to full text
            self.dialogue_engine.current_dialogue.displayed_chars = #self.dialogue_engine.current_dialogue.text
        else
            self.dialogue_engine:next()
        end

    end)
end

function SceneManager:push(scene_name)
    table.insert(self.scene_stack, self.current_scene_name)
    self:switch_to(scene_name)
end

function SceneManager:pop()
    if #self.scene_stack == 0 then
        self:switch_to("main_menu")
        return
    end

    local previous_scene = table.remove(self.scene_stack)
    self:switch_to(previous_scene)
end

function SceneManager:switch_to(scene_name)
    self.is_loading = true
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
    self.is_loading = false
end

function SceneManager:register(name, scene_module)
    self.scenes[name] = scene_module
end

function SceneManager:update(dt)
    if self.current_scene and self.current_scene.update then
        self.current_scene:update(dt)
    end
end

function SceneManager:draw()
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
        HUD.draw(self.current_game_state, self.current_settings, self.dialogue_engine.current_dialogue)
    end
end

function SceneManager:keypressed(key)
    if self.current_scene and self.current_scene.keypressed then
        self.current_scene:keypressed(key)
    end
end

function SceneManager:resize(w, h)
    if self.current_scene and self.current_scene.resize then
        self.current_scene:resize(w, h)
    end
end

return SceneManager
