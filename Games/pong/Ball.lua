Ball = {}

function randomD()
    return math.random(100, 200)
end

function Ball:init(x, y, r)
    ball = {}

    ball.x = x
    ball.y = y
    ball.r = r

    ball.dx = randomD()
    dy = randomD()
    ball.dy = math.random(2) == 1 and dy or dy * -1

    self.__index = self
    setmetatable(ball, self)
    return ball
end

function Ball:update(dt)
    self.x = self.x + dt * self.dx
    self.y = self.y + dt * self.dy

    if self.x < -WINDOW_WIDTH / 2 + self.r then
        self.x = -WINDOW_WIDTH / 2 + self.r
        self.dx = self.dx * -1
    
    elseif self.x > WINDOW_WIDTH / 2 - self.r then
        self.x = WINDOW_WIDTH / 2 - self.r
        self.dx = self.dx * -1
    end

end

function Ball:collides(paddle, topDown)
    x = paddle.x
    y = paddle.y
    r = paddle.r
    
    d = topDown and 1 or -1

    return (((self.x) * d - x) ^ 2 + ((self.y) * d - y) ^ 2) ^ 0.5 < r
end

function Ball:bounce(paddle)
    x = paddle.x
    y = paddle.y
    r = paddle.r
    
    -- self.x = self.x > x and self.x + self.r or self.x - self.r
    self.y = self.dy > 0 and self.y - self.r or self.y + self.r

    self.dy = self.dy * -1.1
    if (self.dx > 0 and self.x > x) or (self.dx < 0 and self.x < x) then
        self.dx = self.dx * 1.2
    else
        self.dx = self.dx * 0.9
    end
end

function Ball:reset(d)
    ball.dx = randomD()
    dy = randomD()
    top = d and d == 1 or math.random(2) == 1
    ball.dy = top and dy * -1 or dy

    ball.x = 0
    ball.y = 0
end

function Ball:render()
    love.graphics.circle('fill', self.x, self.y, self.r) 
end