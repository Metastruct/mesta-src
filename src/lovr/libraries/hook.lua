local hooks = setmetatable({}, {
	__index = function(self, k)
		local t = {}
		self[k] = t

		return t
	end
})
local debug = require'debug'

local _M = setmetatable({}, {
	__index = hooks
})

_M.hooks = hooks

function _M.add(hook_type, name, func)
	if not hooks[hook_type] then
		hooks[hook_type] = {}
	end

	hooks[hook_type][name] = func
end

function _M.remove(hook_type, name)
	if not hooks[hook_type] then return end
	hooks[hook_type][name] = nil
end

local log = require'log'
local inerror

function _M.run(name, ...)
	local h = hooks[name]

	if h ~= nil then
		local ok, a, b, c, d, e

		for k, v in pairs(h) do
			ok, a, b, c, d, e = xpcall(v, debug.traceback, ...)

			if not ok then
				log.error("hook", "fail", name, k)
				log.error(a)

				if not inerror then
					inerror = true
					hook.run("hook.onError", name, k, v)
					inerror = false
				end

				a = nil
			end

			if a ~= nil then return a, b, c, d, e end
		end
	end
end

function _M.run_nointerrupt_nocb(name, ...)
	local h = hooks[name]

	if h ~= nil then
		for k, v in pairs(h) do
			local ok, err = xpcall(v, debug.traceback, ...)

			if not ok then
				log.error("hook", "fail", name, k)
				log.error(err)

				if not inerror then
					inerror = true
					hook.run("hook.onError", name, k, v, err)
					inerror = false
				end
			end
		end
	end
end

_M.call = _M.run
_M.Call = _M.call
_M.Run = _M.run
_M.Add = _M.add
_M.Remove = _M.remove

return _M