local M = {}
local json = require'dkjson'
local io = require'io'
local TS = '%date '

local function gen(obj, name)
	for level, loggerlevel in next, {
		["debug"] = "debug",
		["info"] = "info",
		--["log"] = "info", -- special
		["notice"] = "info",
		["warn"] = "warn",
		["error"] = "error",
		["fatal"] = "fatal"
	} do
		obj[level] = function(msg, ...)
			if select('#', ...) > 0 then end

			if name == "" then
				local i = debug.getinfo(2,'Sl')
				name = i.source:gsub("@src/lovr",""):gsub("%.lua$","") .. ':' .. i.currentline
			end

			msg = {msg, ...}
			print("[" .. name .. ' ' .. loggerlevel:upper() .. "] ", unpack(msg))
		end
	end
end

function M.setup(name)
	gen(M, name)
end

M.setup""

function M.new(name)
	local obj = {}
	gen(obj, name)

	return obj
end

return M