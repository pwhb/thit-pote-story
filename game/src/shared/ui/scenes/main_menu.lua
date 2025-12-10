local constants = require("src.shared.constants")
local scene_manager = require("src.shared.ui.scene_manager")
local scene = {}

local selected = 1
local options = {"Continue", "New Game", "Load", "Settings", "Exit"}

local mode_selected = 1
local modes = {"Visual Novel", "RPG"}

local has_saved_game = false
local show_mode_modal = false

function scene.enter()
    selected = has_saved_game and 1 or 2
    show_mode_modal = false
end

function scene.exit()
    show_mode_modal = false
end

function scene.update(dt)
    if show_mode_modal then
        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            mode_selected = math.max(1, mode_selected - 1)
            love.timer.sleep(0.2)
        elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            mode_selected = math.min(#modes, mode_selected + 1)
            love.timer.sleep(0.2)
        end
    else
        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            selected = math.max(1, selected - 1)
            love.timer.sleep(0.2)
        elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            selected = math.min(#options, selected + 1)
            love.timer.sleep(0.2)
        end
    end
end

function scene.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local center_x = width / 2

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(constants.GAME_NAME, 0, 20, width, "center")
    local start_y = height / 2 - (#options * 15)
    for i, option in ipairs(options) do
        local color = (i == selected) and {1, 0, 1} or {1, 1, 1}
        if option == "Continue" and not has_saved_game then
            color = {0.5, 0.5, 0.5}
        end
        love.graphics.setColor(unpack(color))
        love.graphics.printf(option, 0, start_y + (i - 1) * 30, width, "center")
    end

    if show_mode_modal then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, width, height)

        local modal_w, modal_h = 300, 120
        local modal_x = center_x - modal_w / 2
        local modal_y = height / 2 - modal_h / 2

        love.graphics.setColor(0.1, 0.1, 0.1, 0.9)
        love.graphics.rectangle("fill", modal_x, modal_y, modal_w, modal_h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", modal_x, modal_y, modal_w, modal_h)

        love.graphics.printf("Select Mode", modal_x, modal_y + 10, modal_w, "center")

        local button_spacing = modal_w / (#modes + 1)
        for i, mode in ipairs(modes) do
            local btn_x = modal_x + i * button_spacing
            local btn_y = modal_y + 70

            love.graphics.setColor((i == mode_selected) and {1, 0, 1} or {1, 1, 1})

            local text_w = love.graphics.getFont():getWidth(mode)
            love.graphics.print(mode, btn_x - text_w / 2, btn_y)
        end
    end
end

function scene.keypressed(key)
    if show_mode_modal then
        if key == "return" or key == "space" then
            local choice = modes[mode_selected]
            if choice == "Visual Novel" then
                print(choice)

            elseif choice == "RPG" then
                print(choice)

            end
        elseif key == "escape" then
            show_mode_modal = false
        end
    else
        if key == "return" or key == "space" then
            local choice = options[selected]
            if choice == "Continue" and has_saved_game then
                show_mode_modal = true
            elseif choice == "New Game" then
                show_mode_modal = true
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
return scene
