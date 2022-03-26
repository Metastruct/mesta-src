misc = require'misc'
log = require'log'
lovr.mouse = require'mouse'
lovr.filesystem.mount('assets/', '/')
local reload=require'mestareloader'
reload.hook()
hook.update.mestareloader=reload.update
misc.loadExtensions()
misc.loadAddons()
log.debug("Loaded")