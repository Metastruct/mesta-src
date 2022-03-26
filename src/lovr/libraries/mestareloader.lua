-- Hooks dofile to let primitive reloading happen for them
local M = {
	_NAME = 'reloader'
}

local log = require'log'.new('reloader')
local targets = {}

M.watcher = coroutine.wrap(function()
	local n = 0

	while true do
		for path, lastModified in pairs(targets) do
			n = n + 1

			if n > 5 then
				coroutine.yield()
			end

			local nowModified = lovr.filesystem.getLastModified(path)

			if nowModified > lastModified then
				targets[path] = nowModified
				log.debug('Reloading', path)
				M.reload_file(path)
			end
		end
	end
end)

function M.add(path)
	targets[path] = lovr.filesystem.getLastModified(path)
end

function M.update()
	M.watcher()
end

M.dofile_noreload = M.dofile_noreload or dofile

function M.reload_file(filename)
	local f, err = loadfile(filename)

	if not f then
		log.error(err)
	end

	local ok, err = xpcall(f, debug.traceback)

	if not ok then
		log.error(err)
	end
end

function M.dofile(path)
	M.add(path)

	return M.dofile_noreload(path)
end

function M.hook()
	_G.dofile = M.dofile
end

function M.getTable()
	return targets
end

return M