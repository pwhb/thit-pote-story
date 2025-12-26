local GameState = require("src.shared.store.game_state")
local Settings = require("src.shared.store.settings")
local AssetLoader = require("src.shared.store.asset_loader")
local constants = require("src.shared.constants")
local DialogueEngine = require("src.shared.store.dialogue_engine")
local dialogue_box = {
    ---@type love.Image
    avatar = nil,
    choices = {},
    selected_choice = nil
}

local function utf8_safe_sub(str, start_char, end_char)
    local pos = 1
    local current_char = 1
    local start_byte = 1
    local end_byte = #str

    while pos <= #str and current_char < start_char do
        local c = str:byte(pos)
        if c < 128 then
            pos = pos + 1
        elseif c < 224 then
            pos = pos + 2
        elseif c < 240 then
            pos = pos + 3
        else
            pos = pos + 4
        end
        current_char = current_char + 1
    end
    start_byte = pos

    while pos <= #str and current_char <= end_char do
        local c = str:byte(pos)
        if c < 128 then
            pos = pos + 1
        elseif c < 224 then
            pos = pos + 2
        elseif c < 240 then
            pos = pos + 3
        else
            pos = pos + 4
        end
        current_char = current_char + 1
    end
    end_byte = pos - 1

    return str:sub(start_byte, end_byte)
end

function dialogue_box:draw_avatar()
    if not self.avatar then
        return
    end
    local img_w, img_h = self.avatar:getDimensions()
    local scale_x = constants.AVATAR_W / img_w
    local scale_y = constants.AVATAR_H / img_h
    love.graphics.setColor(1, 1, 1, 0.75)
    love.graphics.draw(self.avatar, self.box_x, self.box_y - constants.AVATAR_H, 0, scale_x, scale_y)
end

function dialogue_box:draw_choices()
    if #self.choices == 0 then
        return
    end

    local font = love.graphics.newFont(16)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    for i, choice in ipairs(self.choices) do
        local x = self.box_x + constants.AVATAR_W + constants.CHOICE_PADDING
        local y = self.box_y - (i) * constants.CHOICE_H
        love.graphics.print(choice.text, x, y)
    end
end

function dialogue_box:draw()
    local dialogue = DialogueEngine.current_dialogue
    if not dialogue then
        return
    end
    local text = dialogue.text
    if not text then
        return
    end

    local w, h = love.graphics.getDimensions()

    self.box_x = 30
    self.box_y = h - 120

    local box_width, box_height = w - self.box_x * 2, 100
    if w > 1024 then
        box_width = 960
        self.box_x = w / 2 - box_width / 2
    end
    local corner_radius = 8
    local padding = 20

    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", self.box_x + 4, self.box_y + 4, box_width, box_height, corner_radius, corner_radius)

    love.graphics.setColor(0.1, 0.1, 0.15, 0.4)
    love.graphics.rectangle("fill", self.box_x, self.box_y, box_width, box_height, corner_radius, corner_radius)

    if dialogue.speaker then
        local speaker = GameState.character_registry:get_character(dialogue.speaker)
        local name = speaker.name[speaker.name_index][Settings.lang]
        self.avatar = AssetLoader.avatar_assets[dialogue.speaker]["default"]
        love.graphics.setColor(0.8, 0.8, 1, 1)
        love.graphics.setFont(love.graphics.newFont(18))
        love.graphics.printf(name, self.box_x + padding, self.box_y + padding, box_width - padding * 2, "left")
    end

    if dialogue.type == "choice" then
        self.choices = dialogue.choices
    else
        self.choices = {}
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(16))

    local visible_text = utf8_safe_sub(dialogue.text, 1, dialogue.displayed_chars)

    if dialogue.type == "narration" then
        visible_text = "> " .. visible_text
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(16))
    local text_y = dialogue.speaker and self.box_y + padding + 36 or self.box_y + padding
    love.graphics.printf(visible_text, self.box_x + padding, text_y, box_width - padding * 2, "left")

    self:draw_avatar()

    self:draw_choices()
end

return dialogue_box
