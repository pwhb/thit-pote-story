local constants = require("src.shared.constants")
local scene_manager = require("src.shared.ui.scene_manager")
local draw = require("src.shared.ui.utils.draw")
local ux = require("src.shared.ui.utils.ux")
local scene = {}

local options = {"Continue", "New Game", "Load", "Settings", "Exit"}

local modes = {"Visual Novel", "2D RPG"}

function scene:enter()
    self.selected = 1
    self.mode_selected = 1
    self.has_saved_game = false
    self.selected = self.has_saved_game and 1 or 2
    self.show_mode_modal = false

    self.song = love.audio.newSource("assets/audio/background/doh_tha_di_ya_nay_mal.ogg", "stream")
    love.audio.play(self.song)
    love.audio.setVolume(0.1)

    self.select_sound = love.audio.newSource("assets/audio/bfxr/select.wav", "static")
    self.change_sound = love.audio.newSource("assets/audio/bfxr/change_2.wav", "static")

    self.background = love.graphics.newImage("assets/image/background/main_menu.jpg")
    local img_w, img_h = self.background:getDimensions()
    local screen_w, screen_h = love.graphics.getDimensions()

    local scale_x = screen_w / img_w
    local scale_y = screen_h / img_h
    self.bg_scale = math.max(scale_x, scale_y)

    self.bg_offset_x = (img_w * self.bg_scale - screen_w) / 2
    self.bg_offset_y = (img_h * self.bg_scale - screen_h) / 2
    self.title_font = love.graphics.newFont(48)
    self.menu_font = love.graphics.newFont(32)
end

function scene:exit()
    self.show_mode_modal = false
    love.audio.stop()
end

function scene:change_option_ux()
    ux.action_ux(self.change_sound)
end

function scene:select_option_ux()
    ux.action_ux(self.select_sound)
end

function scene:update(dt)
    if self.show_mode_modal then
        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            self.mode_selected = math.max(1, self.mode_selected - 1)
            self:change_option_ux()
        elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            self.mode_selected = math.min(#modes, self.mode_selected + 1)
            self:change_option_ux()
        end
    else
        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            self.selected = math.max(1, self.selected - 1)
            self:change_option_ux()
        elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            self.selected = math.min(#options, self.selected + 1)
            self:change_option_ux()
        end
    end
end

function scene:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.background, -self.bg_offset_x, -self.bg_offset_y, 0, self.bg_scale, self.bg_scale)
    local center_x = width / 2

    draw.render_text(constants.GAME_NAME, width / 2, 30, {
        font = self.title_font,
        color = {1, 1, 1},
        align = "center",
        shadow_offset_x = 5,
        shadow_offset_y = 5
    })
    local start_y = height / 2 - (#options * 15)

    for i, option in ipairs(options) do
        local color = (i == self.selected) and {1, 0, 0} or {1, 1, 1}
        if option == "Continue" and not self.has_saved_game then
            color = {0.5, 0.5, 0.5}
        end

        draw.render_text(option, width / 2, start_y + (i - 1) * 60, {
            font = self.menu_font,
            color = color,
            align = "center",
            shadow_offset_x = 3,
            shadow_offset_y = 3
        })
    end

    if self.show_mode_modal then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, width, height)

        local modal_w, modal_h = 540, 180
        local modal_x = center_x - modal_w / 2
        local modal_y = height / 2 - modal_h / 2

        love.graphics.setColor(0.1, 0.1, 0.1, 0.9)
        love.graphics.rectangle("fill", modal_x, modal_y, modal_w, modal_h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", modal_x, modal_y, modal_w, modal_h)

        love.graphics.printf("Select Mode", modal_x, modal_y + 30, modal_w, "center")

        local button_width = 240 -- Fixed width for both buttons
        local button_spacing = 20
        local total_width = (#modes * button_width) + ((#modes - 1) * button_spacing)
        local start_x = modal_x + (modal_w - total_width) / 2 -- Center the whole group

        for i, mode in ipairs(modes) do
            local btn_x = start_x + (i - 1) * (button_width + button_spacing)
            local btn_y = modal_y + 90

            -- Optional: Draw subtle background for selected
            if i == self.mode_selected then
                love.graphics.setColor(0.3, 0.3, 0.3, 0.6)
                love.graphics.rectangle("fill", btn_x, btn_y - 2, button_width, 42, 16, 16, 4)
            end

            -- Text (centered in button)
            love.graphics.setColor((i == self.mode_selected) and {1, 0, 0} or {1, 1, 1})
            love.graphics.printf(mode, btn_x, btn_y, button_width, "center")
        end
    end
end

function scene:keypressed(key)
    if self.show_mode_modal then
        if key == "return" or key == "space" then
            self:select_option_ux()
            local choice = modes[self.mode_selected]
            if choice == "Visual Novel" then
                scene_manager:switch_to("vn")
            elseif choice == "RPG" then
                scene_manager:switch_to("rpg")
            end
        elseif key == "escape" then
            self.show_mode_modal = false
        end
    else
        if key == "return" or key == "space" then
            self:select_option_ux()
            local choice = options[self.selected]
            if choice == "Continue" and self.has_saved_game then
                self.show_mode_modal = true
            elseif choice == "New Game" then
                self.show_mode_modal = true
            elseif choice == "Load" then
                scene_manager:switch_to("load_menu")
            elseif choice == "Settings" then
                scene_manager:switch_to("settings")
            elseif choice == "Exit" then
                love.event.quit()
            end
        elseif key == "escape" then
            love.event.quit()
        end

    end
end

function scene:resize(w, h)
    if self.background then
        local img_w, img_h = self.background:getDimensions()

        -- Recompute scale to cover
        local scale_x = w / img_w
        local scale_y = h / img_h
        self.bg_scale = math.max(scale_x, scale_y)

        -- Recompute center crop offset
        self.bg_offset_x = (img_w * self.bg_scale - w) / 2
        self.bg_offset_y = (img_h * self.bg_scale - h) / 2
    end
end
return scene
