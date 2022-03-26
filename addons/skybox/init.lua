local skybox
local graphics = lovr.graphics
function hook.load.skybox()
	skybox = lovr.graphics.newTexture('materials/skybox/moonlit_golf_2k.hdr', {
		mipmaps = false,
	})
end

function hook.drawSkybox.skybox()
	graphics.setColor(1, 1, 1)
	graphics.skybox(skybox)
end