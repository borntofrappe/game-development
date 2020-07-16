Paddle = {}

function Paddle:init(cx, cy, r, bottom_half)
    paddle = {}

    paddle.cx = cx
    paddle.cy = cy
    paddle.r = r

    paddle.startAngle = bottom_half and 0 or math.pi
    paddle.endAngle = paddle.startAngle + math.pi

    self.__index = self
    setmetatable(paddle, self)

    return paddle
end

function Paddle:render()
    love.graphics.arc('fill', self.cx, self.cy, self.r, self.startAngle, self.endAngle)
end