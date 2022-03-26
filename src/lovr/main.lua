local misc = require'misc'
local log = require'log'
lovr.mouse = require'mouse'
lovr.filesystem.mount("assets/", "/")

local font = lovr.graphics.newFont(36)
font:setFlipEnabled(true)
font:setPixelDensity(1)

misc.loadExtensions()
misc.loadAddons()
