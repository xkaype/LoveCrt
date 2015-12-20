function love.load()
	-- set display mode
	love.window.setMode(768, 720)
	love.window.setTitle("CRT Effect Demonstration")

	-- default filter
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- create canvas for shader
	canvas = love.graphics.newCanvas()
	canvas:setFilter("linear", "linear")

	-- load assets
	font = love.graphics.newFont("fonts/font.otf", 10);
	love.graphics.setFont(font)

	shader = love.graphics.newShader("crt/shader.glsl")
	love.graphics.setShader(shader)

	overlay = love.graphics.newImage("crt/overlay.png")
	overlay:setFilter("linear", "linear")

	ntsc = love.graphics.newImage("crt/ntsc.png")
	ntsc:setWrap("repeat", "repeat")
	ntscQuad = love.graphics.newQuad(0, 0, 768 / 3, 720 / 3, 3, 3)

	shadowmask = love.graphics.newImage("crt/shadowmask.png")
	shadowmask:setWrap("repeat", "repeat")
	shadowmask:setFilter("linear", "linear")
	shadowmaskQuad = love.graphics.newQuad(0, 0, 768, 720, 12, 6)

	test = love.graphics.newImage("test_images/smb.png")
end

function love.draw()
	love.graphics.setCanvas(canvas)

	-- game
	love.graphics.push()
	love.graphics.scale(3)
	love.graphics.draw(test, 0, 0, 0, (256/test:getWidth()), (240/test:getHeight()))
	love.graphics.pop()

	-- ntsc artifacts
	love.graphics.push()
	love.graphics.scale(3)
	love.graphics.setColor(255, 255, 255, 16)
	love.graphics.setBlendMode("additive")
	love.graphics.draw(ntsc, ntscQuad, 0,0, 0, 1,1)
	love.graphics.setBlendMode("alpha")
	love.graphics.pop()

	-- shadow mask
	love.graphics.push()
	love.graphics.scale(1)
	love.graphics.setColor(255, 255, 255, 32)
	love.graphics.draw(shadowmask, shadowmaskQuad, 0,0, 0, 1,1)
	love.graphics.pop()

	love.graphics.push()
	love.graphics.scale(1)

	-- reset color
	love.graphics.setColor(255, 255, 255, 255)

	-- draw canvas
	local offs = 24
	love.graphics.setCanvas()
	love.graphics.setShader(shader)
	love.graphics.draw(canvas, (offs/2)*3, (offs/2)*3, 0, ((256-offs)*3) / love.graphics.getWidth(), ((240-offs)*3) / love.graphics.getHeight())
	love.graphics.setShader()

	love.graphics.draw(overlay, ((offs-12)/2)*3, ((offs-12)/2)*3, 0, ((256-(offs-12))*3) / love.graphics.getWidth(), ((240-(offs-12))*3) / love.graphics.getHeight())
	love.graphics.pop()
end

function love.keypressed(k)
	if k == "escape" then
		love.event.quit()
	end
end