local M = {}

function M.render_text(text, x, y, opts)
    opts = opts or {}
    local font = opts.font or love.graphics.getFont()
    local color = opts.color or {1, 1, 1}
    local shadow = opts.shadow == nil and true or opts.shadow
    local align = opts.align or "left"

    love.graphics.setFont(font)

    local true_x = x
    if align == "center" then
        true_x = x - font:getWidth(text) / 2
    elseif align == "right" then
        true_x = x - font:getWidth(text)
    end

    if shadow then
        love.graphics.setColor(0, 0, 0, opts.shadow_alpha or 0.6)
        love.graphics.print(text, true_x + (opts.shadow_offset_x or 2), y + (opts.shadow_offset_y or 2))
    end

    love.graphics.setColor(unpack(color))
    love.graphics.print(text, true_x, y)
    love.graphics.setColor(1, 1, 1)
end

return M
