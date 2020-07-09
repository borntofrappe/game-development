Ball = {}

function Ball:init(x, y, r)
    ball = {}

    ball.x = x
    ball.y = y
    ball.r = r

    self.__index = self
    setmetatable(ball, self)
    return ball
end

function Ball:render()
    love.graphics.circle('fill', self.x, self.y, self.r) 
end