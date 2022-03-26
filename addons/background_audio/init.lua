-- Play a continuous sine wav
function hook.load.bgaudio()
  source = lovr.audio.newSource('sound/environments/drewhalasz_urban.ogg')
  source:setLooping(true)
  source:play()
end

-- Oscillate volume
function hook.update.bgaudio()
  source:setVolume(0.5)
end
