
local MISC = {}
local exports=MISC

inspect = require'inspect'
log = require'log'

function isfunction(obj)
	return type(obj) == "function"
end

function isstring(obj)
	return type(obj) == "string"
end

function isnumber(obj)
	return type(obj) == "number"
end

function isbool(obj)
	return type(obj) == "boolean"
end

function IsValid(obj)
	return obj and obj.IsValid and obj:IsValid()
end

function PrintTable(...)
	for n = 1, select('#', ...) do
		local e = select(n, ...)
		print(inspect.inspect(e))
	end
end

local io = require'io'

function ErrorNoHaltWithStack(...)
	local str = '[ERROR] ' .. debug.traceback(table.concat{...}, 2) .. '\n'
	io.stderr:write(str)
	io.stderr:flush()

	return str
end

hook = require'hook'
log.debug("OS", lovr.system.getOS(), "Cores", lovr.system.getCoreCount(), "Features", inspect(lovr.graphics.getFeatures()))
local sql = require'sql'
local ok, ret = xpcall(sql._init, debug.traceback)

if not ok then
	log.error(ret)
end

exports.ErrorNoHaltWithStack = ErrorNoHaltWithStack
exports.isstring = isstring
exports.isfunction = isfunction
exports.isnumber = isnumber
exports.isbool = isbool
exports.IsValid = IsValid
local exports = MISC

function exports.loadAddons()
	for _, dir in pairs(lovr.filesystem.getDirectoryItems('addons')) do
		log.debug('Running init on ', dir)
		dofile('addons/' .. dir .. '/init.lua')
		--TODO: helpers to mount assets if the addon wants it
		--TODO: selectively loading addons
		--TODO: return value should be?
		--TODO: whole game addons vs 'scene/level' addons?
	end
end

function exports.loadExtensions()
	for _, name in pairs(lovr.filesystem.getDirectoryItems('src/lovr/extensions')) do
		dofile('src/lovr/extensions/' .. name)
	end
end


do
		
	local stores = {}

	function exports.getScriptStorage()
		local id = debug.getinfo(2, 'Sl')
		local t = stores[id.source]

		if not t then
			t = {}
			stores[id.source] = t
		end

		return t
	end

end

return exports