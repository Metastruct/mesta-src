-- The launcher is the splash screen for configuring the settings and finally launching the game
-- TODO: Settings are stored in settings.json?

print('MESTA Launcher. Using ',lovr.graphics.getHardware and lovr.graphics.getHardware().renderer or 'old lovr')

local shader = require 'launcher_shader'
lovr.mouse = require 'launcher_mouse'
local json = require'dkjson'
local mirror = lovr.mirror
local font = lovr.graphics.newFont(36)
font:setFlipEnabled(true)
font:setPixelDensity(1)
local scrw = lovr.graphics.getWidth()
local scrh = lovr.graphics.getHeight()
local scraspect = scrw/scrh
local now = lovr.timer.getTime()
local selection = 0

local fontscale = 2 / lovr.graphics.getHeight()

-- Screen-space coordinate system
local matrix = lovr.math.newMat4():orthographic(-scraspect, scraspect, -1, 1, -64, 64)

local colSelected = {147 / 255, 63 / 255, 147 / 255, 1}
local color_white = {1, 1, 1, 1}

local function handleSelection()
	local vr = selection == 1

	print(vr and "VR selected" or "Non-VR selected")

	-- TODO, proper config system
	local cfg = vr and {} or {headset = false}
	local config = json.encode(cfg)

	print("writing: config.json")
	-- the launcher is already mounted in appdata
	local written = lovr.filesystem.write('config.json', config)
	print("wrote: " .. tostring(written) .. " bytes")

	print("Launching game. This window will close after the game closes.")
	wantQuit = true
	require'io'.popen("start ..\\lovr\\lovr.exe --console ../mesta")
	lovr.event.quit(0)
end

function lovr.load()
	lovr.handlers['mousepressed'] = function(x,y)
		print("MOUSE",x,y)

		if selection == 0 then return end

		handleSelection()
	end

	lovr.handlers['mousemoved'] = function(x,y)
		if y < scrh*0.5 then selection = 0 return end

		if x < scrw*0.5 then selection = 1 end
		if x > scrw*0.5 then selection = 2 end
	end
end

--awful
function drawUI()
	lovr.graphics.setColor(selection == 1 and colSelected or color_white)
	lovr.graphics.plane('fill', -0.5, 0.5, 0, 0.5, 0.25)
	lovr.graphics.setColor(selection == 2 and colSelected or color_white)
	lovr.graphics.plane('fill', 0.5, 0.5, 0, 0.5, 0.25)

	lovr.graphics.setColor(0, 0, 0, 1)
	lovr.graphics.setFont(font)
	lovr.graphics.print("Yes-VR", -0.5, 0.5, 0, fontscale)

	lovr.graphics.print("Non-VR", 0.5, 0.5, 0, fontscale)
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

	drawUI()
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