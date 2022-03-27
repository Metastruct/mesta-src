lovr.filesystem.setRequirePath([[src/lovr/?.lua;src/lovr/lua/?.lua;src/lovr/libraries/?.lua;src/lovr/libraries/?/init.lua;launcher/?.lua;]] .. lovr.filesystem.getRequirePath())

function lovr.conf(t)
	require'table_ext'
	local json = require'dkjson'

	local conf
	local cfgPath = lovr.filesystem.getAppdataDirectory() .. '\\LOVR\\mesta'

	print("mounting: " .. cfgPath)
	local mounted = lovr.filesystem.mount(cfgPath)

	if mounted then

		print("reading: config.json")
		local confstring = lovr.filesystem.read("config.json")

		if confstring then
			conf = json.decode(confstring)

			if table.IsEmpty(conf) then
				print("config.json is empty?")
			end
		else
			print("config.json not found, using default config.")
		end

		print("unmounting: " .. cfgPath)
		lovr.filesystem.unmount(cfgPath)
	else
		print("failed to mount: " .. cfgPath)
		conf =  {}
	end

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