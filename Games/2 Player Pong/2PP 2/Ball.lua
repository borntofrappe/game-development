Ball = {}

function Ball:init(cx, cy, r)
    ball = {}

    ball.cx = cx
    ball.cy = cy
    ball.r = r

    self.__index = self
    setmetatable(ball, self)

    return ball
end

function Ball:render()
    love.graphics.circle('fill', self.cx, self.cy, self.r)
end