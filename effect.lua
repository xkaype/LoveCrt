-- motion blur is from https://gist.github.com/MichaelCarius/7653273

local effect = {}

effect.numFrames = 3
effect.fadeBase = 0x22

local canvases

function effect.init()
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
        love.graphics.draw(canvas, (offs / 2) * getScale(), (offs / 2) * 3, 0, ((getWidth() - offs) * getScale()) / love.graphics.getWidth(), ((getHeight() - offs) * getScale()) / love.graphics.getHeight())
    end

    love.graphics.setShader()
    love.graphics.draw(overlay, ((offs - 12) / 2) * getScale(), ((offs - 12) / 2) * getScale(), 0, ((getWidth() - (offs - 12)) * getScale()) / love.graphics.getWidth(), ((getHeight() - (offs - 12)) * getScale()) / love.graphics.getHeight())
end

return effect