-- The launcher is the splash screen for configuring the settings and finally launching the game
-- TODO: Settings are stored in settings.json?

print('MESTA Launcher. Using ',lovr.graphics.getHardware and lovr.graphics.getHardware().renderer or 'old lovr')

local shader = require 'launcher_shader'
lovr.mouse = require 'launcher_mouse'
local mirror = lovr.mirror
local font = lovr.graphics.newFont(36)
font:setFlipEnabled(true)
font:setPixelDensity(1)
local scrw = lovr.graphics.getWidth()
local scrh = lovr.graphics.getHeight()
local scraspect = scrw/scrh
local now = lovr.timer.getTime()
local triangle = lovr.graphics.newMesh(
	{{0,-1,0, 0,0,1}, {0.75,1,0, 0,0,1}, {-0.75,1,0, 0,0,1}},
	'triangles', 'static'
	)




local fontscale = 2 / lovr.graphics.getHeight()

-- Screen-space coordinate system
local matrix = lovr.math.newMat4():orthographic(-scraspect, scraspect, -1, 1, -64, 64)

local skybox
function lovr.load()
	
	lovr.handlers['mousepressed'] = function(x,y)
		print("MOUSE",x,y)
		print("Launching game. This window will close after the game closes.")
		wantQuit = true
		require'io'.popen("start ..\\lovr\\lovr.exe --console ../mesta")
		lovr.event.quit(0)
	end
end

-- Draw HUD overlay
function lovr.mirror()
	mirror()
	--lovr.graphics.clear() -- Uncomment to hide headset view in background of window
	lovr.graphics.setShader(nil)
	lovr.graphics.setDepthTest(nil)
	lovr.graphics.origin()
	--lovr.graphics.rotate(now*5,1,1,1)
	lovr.graphics.setViewPose(1, mat4())
	lovr.graphics.setProjection(1, matrix) -- Switch to screen space coordinates

	-- Draw instructions
	lovr.graphics.setColor(1,1,1,1)
	lovr.graphics.setFont(font)
	lovr.graphics.print("WIP: Click to Launch\nMeant to choose settings like VR/Desktop, etc", 0, 0, 0, fontscale)
end


function lovr.draw()

	lovr.graphics.setDepthTest('lequal', true) -- mirror() will have disabled this
	lovr.graphics.setShader(shader)
	lovr.graphics.setColor(0,1,1)

	lovr.graphics.setShader()

	if not lovr.mouse then -- If you can't click, you can't create any blocks
		lovr.graphics.print('This example only works on a desktop computer.', 0, 1.7, -3, .2)
	end
end

function lovr.update(dt)
	now = now + dt
	if wantQuit then
		lovr.event.quit(0)	
	end

end