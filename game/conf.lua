local constants = require("src.shared.constants")

function love.conf(t)
    t.window.width = 1024
    t.window.height = 768
    t.window.resizable = true
    t.window.title = constants.GAME_NAME
end
