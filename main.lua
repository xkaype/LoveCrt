function love.load()
	-- set display mode
	love.window.setMode(768, 720)
	love.window.setTitle("CRT Effect Demonstration")

	-- set default filter
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- create canvas for shader
	canvas = love.graphics.newCanvas()
	canvas:setFilter("linear", "linear")

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
	shadowmask:setFilter("linear", "linear")
	shadowmaskQuad = love.graphics.newQuad(0, 0, getDisplayWidth(), getDisplayHeight(), 12, 6)

	test = love.graphics.newImage("testing/contra.png")
end

function love.draw()
	love.graphics.setCanvas(canvas)

	-- game
	love.graphics.push()
	love.graphics.scale(3)
	love.graphics.draw(test, 0, 0, 0, (getWidth()/test:getWidth()), (getHeight()/test:getHeight()))

	-- ntsc artifacts
	love.graphics.scale(3)
	love.graphics.setColor(255, 255, 255, 24)
	love.graphics.draw(ntsc, ntscQuad, 0,0, 0, 1,1)
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
	love.graphics.draw(canvas, (offs/2)*getScale(), (offs/2)*3, 0, ((getWidth()-offs)*getScale()) / love.graphics.getWidth(), ((getHeight()-offs)*getScale()) / love.graphics.getHeight())
	love.graphics.setShader()

	love.graphics.draw(overlay, ((offs-12)/2)*getScale(), ((offs-12)/2)*getScale(), 0, ((getWidth()-(offs-12))*getScale()) / love.graphics.getWidth(), ((getHeight()-(offs-12))*getScale()) / love.graphics.getHeight())
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