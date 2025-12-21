local AssetLoader = require("src.shared.store.asset_loader")
local GameState = require("src.shared.store.game_state")
local DialogueEngine = require("src.shared.store.dialogue_engine")
local constants = require("src.shared.constants")
local CommandRunner = {}

function CommandRunner.play_sound(args)
    local sound_name = args[1]
    if AssetLoader.audio_assets[sound_name] then
        AssetLoader.audio_assets[sound_name]:setVolume(constants.SOUND_EFFECT_VOLUME)
        AssetLoader.audio_assets[sound_name]:play()
    end
    DialogueEngine.next()
end

function CommandRunner.update_name_index(args)
    local code, diff = args[1], args[2]
    GameState.character_registry:update_name_index(code, diff)
    DialogueEngine.next()
end
return CommandRunner
