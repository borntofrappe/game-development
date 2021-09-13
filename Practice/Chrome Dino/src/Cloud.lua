Cloud = {}

function Cloud:new(x, y)
    local x = x or love.math.random(VIRTUAL_WIDTH, VIRTUAL_WIDTH * 2)
    local y = y or love.math.random(math.floor(VIRTUAL_HEIGHT / 2) - CLOUD_HEIGHT)
    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = CLOUD_WIDTH,
        ["inPlay"] = true,
        ["dx"] = love.math.random(math.floor(SCROLL_SPEED / 3), math.floor(SCROLL_SPEED / 2))
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Cloud:update(dt)
    if self.inPlay then
        self.x = self.x - self.dx * dt
        if self.x < -self.width then
            self.inPlay = false
        end
    end
end

function Cloud:render()
    if self.inPlay then
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.draw(gTextures["spritesheet"], gQuads["cloud"], math.floor(self.x), math.floor(self.y))
    end
end
