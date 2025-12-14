local scene_manager = require("src.shared.ui.scene_manager")
local game_state = require("src.shared.store.game_state")
local settings = require("src.shared.store.settings")
local ux = require("src.shared.ui.utils.ux")
local assets = require("data.static.assets.init")
local game = {
    ---@type love.Image
    current_background = nil,
    current_background_sound = nil,
    backgrounds = {},
    sounds = {}
}

function game:load_assets()
    for key, value in pairs(assets.backgrounds) do
        self.backgrounds[key] = love.graphics.newImage(value)
    end

    for key, value in pairs(assets.sounds) do
        self.sounds[key] = love.audio.newSource(value.path, "stream")
        if value.loop then
            self.sounds[key]:setLooping(true)
        end
        if value.volume then
            self.sounds[key]:setVolume(value.volume)
        end
    end
end

function game:enter()
    self:load_assets()
    self.current_background = self.backgrounds["MOON_LIT_JUDSON"]
    self.current_background_sound = self.sounds["FOREST_BIRDSONG_LOOPABLE"]
    love.audio.play(self.current_background_sound)

    local img_w, img_h = self.current_background:getDimensions()
    local screen_w, screen_h = love.graphics.getDimensions()
    local scale_x = screen_w / img_w
    local scale_y = screen_h / img_h
    self.bg_scale = math.max(scale_x, scale_y)
    self.bg_offset_x = (img_w * self.bg_scale - screen_w) / 2
    self.bg_offset_y = (img_h * self.bg_scale - screen_h) / 2

    -- audio
    self.pause_sound = love.audio.newSource("assets/audio/bfxr/pause.wav", "static")

    -- state
    scene_manager.current_game_state = game_state:new()
    scene_manager.current_settings = settings:new()
end

function game:exit()

end

function game:update(dt)

end

function game:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.current_background, -self.bg_offset_x, -self.bg_offset_y, 0, self.bg_scale, self.bg_scale)
end

function game:keypressed(key)
    if key == "escape" then
        ux.action_ux(self.pause_sound)
        scene_manager:push("pause_menu")
    end
end

function game:resize(w, h)
    if self.current_background then
        local img_w, img_h = self.current_background:getDimensions()

        local scale_x = w / img_w
        local scale_y = h / img_h
        self.bg_scale = math.max(scale_x, scale_y)

        self.bg_offset_x = (img_w * self.bg_scale - w) / 2
        self.bg_offset_y = (img_h * self.bg_scale - h) / 2
    end
end

return game
