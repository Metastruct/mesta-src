
local now = lovr.timer.getTime()

local mirror = lovr.mirror

function _G.Now()
	return now
end

function lovr.load(...)
	-- handlers should be created centrally, because otherwise separate addons can't make use of them
	function lovr.handlers.mousepressed(x, y)
		hook.run('mousepressed', x, y)
	end

	return hook.run('load', ...)
end

function lovr.mirror()
	-- Draws the view for desktop
	-- TODO: VR/Desktop mode swapping? 
	--  ALSO Seems we can't really enter/exit VR in LÖVR!!!!
	local ran

	if hook.run('shouldRunMirror')~=false then
		mirror()
		ran = true
	end

	return hook.run('mirror', mirror, ran)
end

function lovr.draw()
	-- Draws the view for VR
	hook.run('drawSkybox')
	return hook.run('draw')
end

function lovr.update(dt)
	-- think hook of sorts
	now = now + dt

	return hook.run_nointerrupt_nocb('update', dt)
end