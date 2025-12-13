local scene_manager = require("src.shared.ui.scene_manager")
local game_state = require("src.shared.store.game_state")
local ux = require("src.shared.ui.utils.ux")
local game = {
    background = nil,
    background_images = {}
}

local assets = {"red_convocation", "moon_lit_judson"}

function game:load_assets()
    for i, asset in ipairs(assets) do
        self.background_images[asset] = love.graphics.newImage(string.format("assets/image/background/%s.jpg", asset))
    end
end

function game:enter()
    self:load_assets()
    self.background_sound = love.audio.newSource("assets/audio/background/forest_birdsong_loopable.ogg", "stream")
    self.background_sound:setLooping(true)
    self.background_sound:setVolume(0.01)
    love.audio.play(self.background_sound)
    self.background = love.graphics.newImage(string.format("assets/image/background/%s.jpg", assets[2]))

    local img_w, img_h = self.background:getDimensions()
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
end

function game:exit()

end

function game:update(dt)

end

function game:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.background, -self.bg_offset_x, -self.bg_offset_y, 0, self.bg_scale, self.bg_scale)
end

function game:keypressed(key)
    if key == "escape" then
        ux.action_ux(self.pause_sound)
        scene_manager:push("pause_menu")
    end
end

function game:resize(w, h)
    if self.background then
        local img_w, img_h = self.background:getDimensions()

        local scale_x = w / img_w
        local scale_y = h / img_h
        self.bg_scale = math.max(scale_x, scale_y)

        self.bg_offset_x = (img_w * self.bg_scale - w) / 2
        self.bg_offset_y = (img_h * self.bg_scale - h) / 2
    end
end

return game
