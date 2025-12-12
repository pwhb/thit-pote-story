local scene_manager = require("src.shared.ui.scene_manager")
local ux = require("src.shared.ui.utils.ux")
local draw = require("src.shared.ui.utils.draw")
local scene = {}

local options = {"Resume", "Save", "Settings", "Main Menu", "Quit"}

function scene:enter()
    self.selected = 1
    self.change_sound = love.audio.newSource("assets/audio/bfxr/change_2.wav", "static")
    -- Fade out game audio, play pause ambience
end

function scene:draw()
    local w, h = love.graphics.getDimensions()

    -- Semi-transparent overlay (so current scene is visible but dimmed)
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- Title: "Step Back" (centered top)
    love.graphics.setColor(1, 1, 1)
    -- Options
    local start_y = h / 2 - (#options * 20)
    local font = love.graphics.newFont(24)
    love.graphics.setFont(font)

    for i, option in ipairs(options) do
        local color = (i == self.selected) and {1, 0, 0} or {1, 1, 1}
        draw.render_text(option, w / 2, start_y + (i - 1) * 60, {
            font = self.menu_font,
            color = color,
            align = "center",
            shadow_offset_x = 3,
            shadow_offset_y = 3
        })
    end
end

function scene:update(dt)
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.selected = math.max(1, self.selected - 1)
        ux.action_ux(self.change_sound)
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.selected = math.min(#options, self.selected + 1)
        ux.action_ux(self.change_sound)
    end
end

function scene:keypressed(key)
    if key == "escape" or key == "p" then
        scene_manager:pop() -- Custom method to return
    elseif key == "return" or key == "space" then
        local choice = options[self.selected]
        if choice == "Resume" then
            scene_manager:pop()
        elseif choice == "Main Menu" then
            scene_manager:switch_to("main_menu")
        elseif choice == "Quit" then
            love.event.quit()
            -- ... handle Save, Settings
        end
        -- ... navigation
    end
end

return scene
