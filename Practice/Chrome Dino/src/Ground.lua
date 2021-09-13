Ground = {}

function Ground:new(x, y)
    local x = x or 0
    local y = y or VIRTUAL_HEIGHT - gTextures["ground"]:getHeight()
    local this = {
        ["x"] = x,
        ["y"] = y
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
end
