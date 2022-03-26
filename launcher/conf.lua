lovr.filesystem.setRequirePath([[src/lovr/?.lua;launcher/?.lua;]] .. lovr.filesystem.getRequirePath())
function lovr.conf(t)
	-- comment for VR
	t.headset.drivers = { 'desktop' }
	t.identity = "mesta"
	t.modules.headset = false
	t.window.title = 'Metastruct Experimental Standalone Testing Application'
	t.window.icon = 'assets/application.png'
	
	t.window.width = 800
	t.window.height = 600
end