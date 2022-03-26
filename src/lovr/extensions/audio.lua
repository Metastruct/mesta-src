function hook.update.audio()
	-- TODO: Desktop pose?
	if lovr.headset then
		lovr.audio.setPose(lovr.headset.getPose())
	else
		return
	end
end