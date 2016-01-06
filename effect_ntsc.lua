--[[
-- This is the effect without the overlay or CRT bending.
-- Motion blur is from https://gist.github.com/MichaelCarius/7653273
--]]

local effect = {}

effect.numFrames = 6
effect.fadeBase = 0x66

local canvases

function effect.init()
    shader = love.graphics.newShader("resources/ntsc.glsl")
    love.graphics.setShader(shader)

    canvases = {}
    for i = 1, effect.numFrames do
        canvases[#canvases + 1] = love.graphics.newCanvas()
        canvases[#canvases]:setFilter("linear", "linear")
    end
end

function effect.preDraw()
    local nextCanvas = table.remove(canvases, 1)
    nextCanvas:clear()
    canvases[#canvases + 1] = nextCanvas
    love.graphics.setCanvas(nextCanvas)
end

function effect.postDraw(offs)
    love.graphics.setCanvas()
    love.graphics.setShader(shader)

    for i, canvas in ipairs(canvases) do
        love.graphics.setColor(0xff, 0xff, 0xff, i == #canvases and 0xff or i / #canvases * effect.fadeBase)
        love.graphics.draw(canvas, (offs / 2) * getScale(), (offs / 2) * getScale(), 0, ((getWidth() - offs) * getScale()) / love.graphics.getWidth(), ((getHeight() - offs) * getScale()) / love.graphics.getHeight())
    end

    love.graphics.setShader()
end

return effect