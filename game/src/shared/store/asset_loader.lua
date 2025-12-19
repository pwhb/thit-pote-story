local Factory = require("src.shared.utils.factory")
local assets = require("data.static.assets.init")
local avatars = require("data.static.characters.init")
--- @class ImageAssetMap : table<string, love.Image>

--- @class AvatarAssetMap : table<string, table<string, love.Image>>

--- @class AudioAssetSpec
--- @field path string
--- @field type? "static"|"stream"|"queue"

--- @class AudioAssetMap : table<string, AudioAssetSpec>

--- @class AssetLoader
--- @field public image_assets ImageAssetMap
--- @field public audio_assets AudioAssetMap
--- @field public avatar_assets AvatarAssetMap
--- @field public load_image_assets fun(v: string[])
--- @field public load_avatar_assets fun(v: string[])
--- @field public load_audio_assets fun(v: string[])
--- @field public clean_up_assets fun(v: string[], type?: "image"|"audio")
local AssetLoader = Factory.encapsulated({
    image_assets = {},
    audio_assets = {},
    avatar_assets = {}
}, function(private)
    return {
        --- @param v string[]
        load_image_assets = function(v)
            for _, key in ipairs(v) do
                private.image_assets[key] = love.graphics.newImage(assets.images[key])
            end
        end,
        --- @param v string[]  
        load_audio_assets = function(v)
            for _, key in ipairs(v) do
                local value = assets.sounds[key]
                local path = value["path"]
                local type = value["type"] and value["type"] or "static"
                private.audio_assets[key] = love.audio.newSource(path, type)
            end
        end,
        --- @param v string[]
        load_avatar_assets = function(v)
            for _, key in ipairs(v) do
                private.avatar_assets[key] = {}
                local avatar_assets = avatars[key]["avatar"]
                for avatar_key, path in pairs(avatar_assets) do
                    private.avatar_assets[key][avatar_key] = love.graphics.newImage(path)
                end
            end

        end,
        --- @param v string[]
        --- @param type? "image"|"audio"
        clean_up_assets = function(v, type)
            type = type or "image"
            for _, key in ipairs(v) do
                private[string.format("%s_assets", type)][key] = nil
            end
        end
    }
end)

return AssetLoader
