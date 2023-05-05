Puck = Class{}

function Puck:init(x, y)
    self.x = x
    self.y = y
    self.r = PUCK.radius
end

function Puck:render()
    love.graphics.circle('fill', self.x, self.y, self.r)
end