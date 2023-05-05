Puck = Class{}


function Puck:getDs()
    dx = math.random(2) == 1 and math.random(PUCK.speed.min, PUCK.speed.max) or math.random(PUCK.speed.min, PUCK.speed.max) * -1
    dy = math.random(2) == 1 and math.random(PUCK.speed.min, PUCK.speed.max) or math.random(PUCK.speed.min, PUCK.speed.max) * -1
    return dx, dy 
end

function Puck:init(x, y)
    self.origin = {
        x = x,
        y = y
    }
    self.x = x
    self.y = y
    self.r = PUCK.radius
    self.dx, self.dy = self:getDs()
end

function Puck:reset()
    self.x, self.y = self.origin.x, self.origin.y
    self.dx, self.dy = self:getDs()
end

function Puck:update(dt)
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt)
end

function Puck:render()
    love.graphics.circle('fill', self.x, self.y, self.r)
end