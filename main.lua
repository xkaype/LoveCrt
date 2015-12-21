function love.load()
	-- load in effect module (processes shader and handles motion blur)
	effect = require('effect')

	-- set display mode
	love.window.setMode(768, 720)
	love.window.setTitle("CRT Effect Demonstration")

	-- set default filter
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- initialize canvas
    effect.init()

	-- load assets
	shader = love.graphics.newShader("resources/shader.glsl")
	love.graphics.setShader(shader)

	overlay = love.graphics.newImage("resources/overlay.png")
	overlay:setFilter("linear", "linear")

	ntsc = love.graphics.newImage("resources/ntsc.png")
	ntsc:setWrap("repeat", "repeat")
	ntsc:setFilter("linear", "linear")
	ntscQuad = love.graphics.newQuad(0, 0, getWidth(), getHeight(), 3, 3)

	shadowmask = love.graphics.newImage("resources/shadowmask.png")
	shadowmask:setWrap("repeat", "repeat")
	shadowmaskQuad = love.graphics.newQuad(0, 0, getDisplayWidth(), getDisplayHeight(), 12, 6)

	test = love.graphics.newImage("testing/contra.png")
end

function love.draw()
	effect.preDraw()

	-- game code goes here
	love.graphics.push()
	love.graphics.scale(3)
	love.graphics.draw(test, 0, 0, 0, (getWidth() / test:getWidth()), (getHeight() / test:getHeight()))
	
	-- ntsc artifacts
	love.graphics.scale(3)
	love.graphics.setColor(255, 255, 255, 32)
	love.graphics.draw(ntsc, ntscQuad, 0, 0, 0, 1, 1)
	love.graphics.pop()

	-- shadow mask
	love.graphics.push()
	love.graphics.scale(1)
	love.graphics.setColor(255, 255, 255, 64)
	love.graphics.setBlendMode("additive")
	love.graphics.draw(shadowmask, shadowmaskQuad, 0, 0, 0, 1, 1)
	love.graphics.setBlendMode("alpha")
	love.graphics.pop()

	-- draw canvas w/ shader
	love.graphics.push()
	love.graphics.scale(1)
	love.graphics.setColor(255, 255, 255, 255)
	effect.postDraw(24)
	love.graphics.pop()
end

function love.keypressed(k)
	if k == "escape" then
		love.event.quit()
	end
end

function getWidth()
	return getDisplayWidth() / getScale()
end

function getHeight()
	return getDisplayHeight() / getScale()
end

function getDisplayWidth()
	return love.graphics.getWidth()
end

function getDisplayHeight()
	return love.graphics.getHeight()
end

function getScale()
	return 3
end