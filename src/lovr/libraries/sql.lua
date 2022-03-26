local exports = {}

function exports._init_kv()
	local code = sqlite.exec(db, [[ CREATE TABLE kv (
  scope TEXT,
  key TEXT,
  value TEXT
); ]])

	if code ~= SQLITE.OK then
		local msg = db:errmsg()
		if msg == "table kv already exists" then return end -- cursed
		error('Database: ' .. msg)
	end
end

local code, db, sqlite, SQLITE
local dbpath = lovr.filesystem.getAppdataDirectory() .. '/cl.db'

function exports._init()
	sqlite = require'sqlite3'('sqlite3')
	SQLITE = sqlite.const
	exports.const = sqlite.const
	local code
	code, db = sqlite.open(dbpath)

	if code ~= SQLITE.OK then
		error('Database Open Failed: ' .. db:errmsg())
	end

	exports.db = db
end

local function prepare(query)
	local code, stmt = sqlite.prepare_v2(db, query)
	if code ~= SQLITE.OK then return nil, db:errmsg(), code end

	return stmt
end

exports.prepare = prepare
--local QUERY_KV_REPLACE = prepare("REPLACE INTO kv VALUES (?,?,?)")
--local QUERY_KV = prepare("SELECT value FROM kv WHERE scope=? AND key=?")

function exports.kv(key, scope, ...)
	local val = ...

	if select('#', ...) == 0 then
		local ret, err = db("SELECT value as v from kv WHERE key = $1 and scope = $2", key, scope)
		if ret == nil and err then return nil, err end
		local val = ret and ret[1] and ret[1].v

		if val then
			assert(val:sub(1, 2) == '\\x', "Invalid hex: " .. val:sub(1, 2))
			val = val:sub(3):fromhex()
		end

		return val
	else
		if val == nil then
			local ret, err, obj = db("DELETE from kv where key = $1 and scope = $2", key, scope)

			if err == nil then
				return ret and ret == 1
			else
				return nil, err
			end
		else
			local hval = tostring(val):tohex()
			local ret, err = db([[
                REPLACE INTO kv (key,scope,value)
				VALUES ($1,$2,decode($3, 'hex'))
				ON CONFLICT (key,scope) DO UPDATE SET value=decode($4, 'hex')]], key, scope, hval, hval)

			if err == nil then
				return ret and ret == 1
			else
				return ret and ret == 1, err
			end
		end
	end
end

function exports.Query(q)
	return ""
end

return exports