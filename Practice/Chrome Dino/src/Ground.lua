Ground = {}

function Ground:new()
    local width = gTextures["ground"]:getWidth()
    local x = 0
    local y = VIRTUAL_HEIGHT - gTextures["ground"]:getHeight()
    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["offset"] = width
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Ground:update(dt)
end

function Ground:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gTextures["ground"], self.x, self.y)
    love.graphics.draw(gTextures["ground"], self.x + self.offset, self.y)
end
