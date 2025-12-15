local M = {}

function M.action_ux(sound)
    love.audio.play(sound)
    love.timer.sleep(0.2)
end
return M
