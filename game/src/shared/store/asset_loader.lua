local Factory = require("src.shared.utils.factory")
local assets = require("data.static.assets.init")

--- @class ImageAssetMap : table<string, string>
--- A map from asset key to image file path.
--- Example: `{ player = "assets/images/player.png" }`

--- @class AudioAssetSpec
--- @field path string
--- @field type? "static"|"stream"|"queue"

--- @class AudioAssetMap : table<string, AudioAssetSpec>
--- A map from asset key to audio spec.
--- Example: `{ jump = { path = "sfx/jump.ogg", type = "static" } }`
--- 
--- @class AssetLoader
--- @field public image_assets table<string, love.Image>
--- @field public audio_assets table<string, love.Source>
--- @field public load_image_assets fun(v: ImageAssetMap)
--- @field public load_audio_assets fun(v: AudioAssetMap)
--- @field public clean_up_assets fun(v: string[], type?: "image"|"audio")
local AssetLoader = Factory.encapsulated({
    image_assets = {},
    audio_assets = {}
}, function(private)
    return {
        --- @param v ImageAssetMap
        load_image_assets = function(v)
            for _, key in ipairs(v) do
                private.image_assets[key] = love.graphics.newImage(assets.images[key])
            end
        end,
        --- @param v AudioAssetMap  
        load_audio_assets = function(v)
            for _, key in ipairs(v) do
                local value = assets.sounds[key]
                local path = value["path"]
                local type = value["type"] and value["type"] or "static"
                private.audio_assets[key] = love.audio.newSource(path, type)
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
