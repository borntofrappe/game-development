Bird = {}

function Bird:new()
    local width = BIRD_WIDTH
    local height = BIRD_HEIGHT

    local x = VIRTUAL_WIDTH
    local y =
        love.math.random(math.floor(VIRTUAL_HEIGHT / 2), VIRTUAL_HEIGHT - gTextures["ground"]:getHeight() - height)

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["height"] = height,
        ["dx"] = math.floor(SCROLL_SPEED * 1.2),
        ["animation"] = Animation:new({1, 2}, 0.12),
        ["inPlay"] = true
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Bird:update(dt)
    if self.inPlay then
        self.animation:update(dt)

        self.x = self.x - self.dx * dt
        if self.x < -self.width then
            self.inPlay = false
        end
    end
end

function Bird:render()
    if self.inPlay then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            gTextures["spritesheet"],
            gQuads["bird"][self.animation:getCurrentFrame()],
            math.floor(self.x),
            math.floor(self.y)
        )
    end
end
