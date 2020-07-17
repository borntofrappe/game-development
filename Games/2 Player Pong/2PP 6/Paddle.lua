Paddle = {}


function Paddle:init(cx, cy, r)
    paddle = {}

    paddle.cx = cx
    paddle.cy = cy
    paddle.r = r

    paddle.dx = 0

    paddle.is_ready = false

    self.__index = self
    setmetatable(paddle, self)

    return paddle
end

function Paddle:render()
    love.graphics.circle('fill', self.cx, self.cy, self.r)
end


function Paddle:update(dt)
    if self.dx > 0 then
        self.cx = math.min(WINDOW_WIDTH - self.r, self.cx + self.dx * dt)
    elseif self.dx < 0 then
        self.cx = math.max(self.r, self.cx + self.dx * dt)
    end
end

function Paddle:reset(dt)
    self.is_ready = false
end