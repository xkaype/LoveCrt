local onlyNTSC = false

function love.load()
	if onlyNTSC then
		effect = require('effect_ntsc')
	else
		effect = require('effect')
	end

	-- set display mode
	love.window.setMode(768, 720)
	love.window.setTitle("CRT Effect Demonstration")

	-- set default filter
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- initialize canvas
	effect.init()

	-- load assets
	ntsc = love.graphics.newImage("resources/ntsc.png")
	ntsc:setWrap("repeat", "repeat")
	ntsc:setFilter("linear", "linear")
	ntscQuad = love.graphics.newQuad(0, 0, getWidth(), getHeight(), ntsc:getDimensions())

	shadowmask = love.graphics.newImage("resources/shadowmask.png")
	shadowmask:setWrap("repeat", "repeat")
	shadowmaskQuad = love.graphics.newQuad(0, 0, getDisplayWidth(), getDisplayHeight(), shadowmask:getDimensions())

	test = love.graphics.newImage("testing/contra.png")
	testQuad = love.graphics.newQuad(0, 0, getWidth(), getHeight(), test:getDimensions())
end

local time = 0

function love.draw()
	effect.preDraw()

	time = time + 1

	-- game code goes here
	love.graphics.push()
	love.graphics.scale(getScale())
	love.graphics.draw(test, testQuad, 0, 0)
	
	-- ntsc artifacts
	love.graphics.scale(getScale())
	love.graphics.setColor(255, 255, 255, 24)
	love.graphics.draw(ntsc, ntscQuad, 0, 0)
	love.graphics.pop()

	-- shadow mask
	if onlyNTSC then
		love.graphics.push()
		love.graphics.scale(1)
		love.graphics.setColor(255, 255, 255, 64)
		love.graphics.setBlendMode("additive")
		love.graphics.draw(shadowmask, shadowmaskQuad, 0, 0)
		love.graphics.setBlendMode("alpha")
		love.graphics.pop()
	end

	-- draw canvas w/ shader
	love.graphics.push()
	love.graphics.scale(1)
	love.graphics.setColor(255, 255, 255, 255)

	if onlyNTSC then
		effect.postDraw(0)
	else
		effect.postDraw(16)
	end

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