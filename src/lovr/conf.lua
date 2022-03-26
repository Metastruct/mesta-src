lovr.filesystem.setRequirePath([[src/lovr/?.lua;src/lovr/lua/?.lua;src/lovr/libraries/?.lua;src/lovr/libraries/?/init.lua;launcher/?.lua;]] .. lovr.filesystem.getRequirePath())

function lovr.conf(t)
	local json = require'dkjson'
	local confstring = lovr.filesystem.read('config.json')
	local conf = confstring and json.decode(confstring) or {}

	if conf.drivers then
		t.headset.drivers = conf.drivers
	end

	t.headset.drivers = {'desktop'}
	t.identity = 'mesta'

	if conf.headset ~= nil then
		t.modules.headset = conf.headset
	end

	--t.modules.headset = false
	t.window.title = 'Metastruct Experimental Standalone Testing Application'
	print(t.window.title)
	t.window.icon = 'assets/application.png'
end