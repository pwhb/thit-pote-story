local scene_manager = require("src.shared.ui.scene_manager")
local game = {}

function game:enter()

end

function game:exit()

end

function game:update(dt)

end

function game:draw()

end

function game:keypressed(key)
    if key == "escape" then
        scene_manager:push("pause_menu") -- Save current scene on stack
    end
end
return game
