local scene_manager = require("src.shared.ui.scene_manager")
local ux = require("src.shared.utils.ux")
local EventBus = require("src.shared.event_bus")
local AssetLoader = require("src.shared.store.asset_loader")
local DialogueEngine = require("src.shared.store.dialogue_engine")
local constants = require("src.shared.constants")
local Game = {
    ---@type love.Image
    current_background = nil,
    ---@type love.Source
    current_background_sound = nil,
    bg_canvas = nil

}

function Game:load_assets(image_assets, audio_assets, character_assets)
    AssetLoader.load_image_assets(image_assets)
    AssetLoader.load_audio_assets(audio_assets)
    AssetLoader.load_avatar_assets(character_assets)
end

function Game:draw_canvas()
    local w, h = love.graphics.getDimensions()
    self.bg_canvas = love.graphics.newCanvas(w, h)
    love.graphics.setCanvas(self.bg_canvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.current_background, -self.bg_offset_x, -self.bg_offset_y, 0, self.bg_scale, self.bg_scale)
    love.graphics.setCanvas() --
end

function Game:enter()
    -- audio
    self.pause_sound = love.audio.newSource(constants.PAUSE_SOUND, "static")

    -- Game
    local script = DialogueEngine.load_script(constants.INIT_SCENE)
    self:load_assets(script.image_assets, script.audio_assets, script.characters)
    if script.background and AssetLoader.image_assets[script.background] then
        self.current_background = AssetLoader.image_assets[script.background]
        local w, h = love.graphics.getDimensions()
        self:resize(w, h)
    end
    if script.background_sound and AssetLoader.audio_assets[script.background_sound] then
        self.current_background_sound = AssetLoader.audio_assets[script.background_sound]
        if script.background_sound_config then
            if script.background_sound_config.volume then
                self.current_background_sound:setVolume(script.background_sound_config.volume)
            end
            if script.background_sound_config.loop then
                self.current_background_sound:setLooping(script.background_sound_config.loop)
            end
        end
        love.audio.play(self.current_background_sound)
    end
end

function Game:exit()

end

function Game:update(dt)
    if scene_manager.current_scene_name == "vn" then
        DialogueEngine.update(dt)
    end
end

function Game:draw()
    love.graphics.draw(self.bg_canvas, 0, 0)
end

function Game:keypressed(key)
    if key == "escape" then
        ux.action_ux(self.pause_sound)
        scene_manager:push("pause_menu")
    end

    if key == "return" or key == "space" then
        EventBus.emit("next_dialogue")
    end
end

function Game:resize(w, h)
    if self.current_background then
        local img_w, img_h = self.current_background:getDimensions()

        local scale_x = w / img_w
        local scale_y = h / img_h
        self.bg_scale = math.max(scale_x, scale_y)

        self.bg_offset_x = (img_w * self.bg_scale - w) / 2
        self.bg_offset_y = (img_h * self.bg_scale - h) / 2
        self:draw_canvas()
    end
end

return Game
