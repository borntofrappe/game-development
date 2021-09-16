Firework = {}

function Firework:new()
    local r = FIREWORK_RADIUS
    local x = WINDOW_WIDTH / 2
    local y = WINDOW_HEIGHT

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["r"] = r,
        ["dy"] = FIREWORK_UPDATE_SPEED.max,
        ["inPlay"] = true
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Firework:update(dt)
    if self.inPlay then
        self.dy =
            (FIREWORK_UPDATE_SPEED.max - FIREWORK_UPDATE_SPEED.min) * (1 - (WINDOW_HEIGHT - self.y) / WINDOW_HEIGHT) +
            FIREWORK_UPDATE_SPEED.min
        self.y = self.y - self.dy * dt
    end
end

function Firework:render()
    if self.inPlay then
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", self.x, self.y, self.r)
    end
end
