Cloud = {}

function Cloud:new(scrollSpeed)
    local width = CLOUD.width
    local height = CLOUD.height
    local x = love.math.random(VIRTUAL_WIDTH, VIRTUAL_WIDTH * 2)
    local y = love.math.random(math.floor(VIRTUAL_HEIGHT / 2) - height)
    local dx = math.floor(scrollSpeed / 3)
    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["height"] = height,
        ["inPlay"] = true,
        ["dx"] = dx
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
        love.graphics.setColor(1, 1, 1, 0.42)
        love.graphics.draw(gTextures["spritesheet"], gQuads["cloud"], math.floor(self.x), math.floor(self.y))
    end
end
