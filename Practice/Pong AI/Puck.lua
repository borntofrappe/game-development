Puck = Class {}

function Puck:getDs()
    dx =
        math.random(2) == 1 and math.random(PUCK.speed.min, PUCK.speed.max) or
        math.random(PUCK.speed.min, PUCK.speed.max) * -1
    dy =
        math.random(2) == 1 and math.random(PUCK.speed.min, PUCK.speed.max) or
        math.random(PUCK.speed.min, PUCK.speed.max) * -1
    return dx, dy
end

function Puck:init(x, y)
    self.origin = {
        x = x,
        y = y
    }
    self.x = x - PUCK.size / 2
    self.y = y - PUCK.size / 2
    self.width = PUCK.size
    self.height = PUCK.size
    self.dx, self.dy = self:getDs()
end

function Puck:reset()
    self.x, self.y = self.origin.x, self.origin.y
    self.dx, self.dy = self:getDs()
end

function Puck:collides(paddle)
    if
        self.x + self.width < paddle.x or self.x > paddle.x + paddle.width or self.y + self.height < paddle.y or
            self.y > paddle.y + paddle.height
     then
        return false
    end

    return true
end

function Puck:update(dt)
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt)
end

function Puck:render()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
