Particle = {}

function Particle:new(x, y, r, dx, dy, dr, color)
    local this = {
        ["x"] = x,
        ["y"] = y,
        ["r"] = r,
        ["dx"] = dx,
        ["dy"] = dy,
        ["dr"] = dr,
        ["color"] = color,
        ["inPlay"] = true
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Particle:update(dt)
    self.x = self.x + self.dx
    self.y = self.y + self.dy
    self.r = math.max(0, self.r - self.dr * dt)

    if self.dx > 0 then
        self.dx = math.max(0, self.dx - dt * 0.1)
    elseif self.dx < 0 then
        self.dx = math.min(0, self.dx + dt * 0.1)
    end

    self.dy = self.dy + GRAVITY * dt

    if self.r == 0 then
        self.inPlay = false
    end
end

function Particle:render()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.circle("fill", self.x, self.y, self.r)
end
