Ground = {}

function Ground:new()
    local width = gTextures["ground"]:getWidth()
    local height = gTextures["ground"]:getHeight()
    local x = 0
    local y = VIRTUAL_HEIGHT - height

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["height"] = height,
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
    love.graphics.draw(gTextures["ground"], math.floor(self.x), math.floor(self.y))
    love.graphics.draw(gTextures["ground"], math.floor(self.x + self.offset), math.floor(self.y))
end
