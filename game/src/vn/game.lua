local scene_manager = require("src.shared.ui.scene_manager")
local ux = require("src.shared.utils.ux")
local assets = require("data.static.assets.init")
local EventBus = require("src.shared.event_bus")
local Game = {
    ---@type love.Image
    current_background = nil,
    ---@type love.Source
    current_background_sound = nil,
    images = {},
    sounds = {}
}

function Game:load_assets()
    for key, value in pairs(assets.images) do
        self.images[key] = love.graphics.newImage(value)
    end

    for key, value in pairs(assets.sounds) do
        local path = value["path"]
        local type = value["type"] and value["type"] or "static"
        self.sounds[key] = love.audio.newSource(path, type)
    end
end

function Game:enter()
    self:load_assets()
    -- audio
    self.pause_sound = love.audio.newSource("assets/audio/bfxr/pause.wav", "static")

    -- Game
    local script = scene_manager.dialogue_engine:load_script("0")
    if script.background and self.images[script.background] then
        self.current_background = self.images[script.background]
        local img_w, img_h = self.current_background:getDimensions()
        local screen_w, screen_h = love.graphics.getDimensions()
        local scale_x = screen_w / img_w
        local scale_y = screen_h / img_h
        self.bg_scale = math.max(scale_x, scale_y)
        self.bg_offset_x = (img_w * self.bg_scale - screen_w) / 2
        self.bg_offset_y = (img_h * self.bg_scale - screen_h) / 2
    end
    if script.background_sound and self.sounds[script.background_sound] then
        self.current_background_sound = self.sounds[script.background_sound]
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
        scene_manager.dialogue_engine:update(dt)
    end
end

function Game:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.current_background, -self.bg_offset_x, -self.bg_offset_y, 0, self.bg_scale, self.bg_scale)
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
    end
end

return Game
