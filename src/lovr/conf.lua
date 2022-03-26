lovr.filesystem.setRequirePath([[src/lovr/?.lua;src/lovr/lua/?.lua;src/lovr/libraries/?.lua;src/lovr/libraries/?/init.lua;launcher/?.lua;]] .. lovr.filesystem.getRequirePath())

function lovr.conf(t)
	local json = require'dkjson'
	local conf = lovr.filesystem.read("config.json")
	conf = conf and json.decode(conf) or {}

	if conf.drivers then
		t.headset.drivers = conf.drivers
	end

	t.identity = "mesta"

	if conf.headset ~= nil then
		t.modules.headset = conf.headset
	end

	--t.modules.headset = false
	t.window.title = 'Metastruct Experimental Standalone Testing Application'
	print(t.window.title)
	t.window.icon = 'assets/application.png'
end