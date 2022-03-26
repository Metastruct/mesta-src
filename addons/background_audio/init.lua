-- Play a continuous sine wav
background_audio = background_audio or {}
local background_audio = background_audio

function hook.load.bgaudio()
	local source = lovr.audio.newSource('sound/environments/drewhalasz_urban.ogg')

	if background_audio.source then
		background_audio.source:stop()
	end

	background_audio.source = source
	source:setLooping(true)
	source:play()
	background_audio.source:setVolume(0.05)
end

--function hook.update.bgaudio()
--end