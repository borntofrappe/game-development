Ball = {}

function Ball:init(x, y, r)
    ball = {}

    ball.x = x
    ball.y = y
    ball.r = r

    ball.dx = math.random(-200, 200)
    ball.dy = math.random(2) == 1 and 200 or -200

    self.__index = self
    setmetatable(ball, self)
    return ball
end

function Ball:update(dt)
    self.x = self.x + dt * self.dx
    self.y = self.y + dt * self.dy

    if self.x < self.r then
        self.x = self.r
        self.dx = self.dx * -1
    
    elseif self.x > WINDOW_WIDTH - self.r then
        self.x = WINDOW_WIDTH - self.r
        self.dx = self.dx * -1
    end

end

function Ball:collides(paddle)
    x = paddle.x
    y = paddle.y
    r = paddle.r

    return ((self.x - x) ^ 2 + (self.y - y) ^ 2) ^ 0.5 < r
end

function Ball:bounce(paddle)
    self.dy = self.dy * -1.1

    if self.x < paddle.x then
        self.dx = -math.random(50, 200)
    else
        self.dx = math.random(50, 200)
    end

end

function Ball:reset()
    ball.x = WINDOW_WIDTH / 2
    ball.y = WINDOW_HEIGHT / 2

    ball.dx = math.random(-200, 200)
    ball.dy = math.random(2) == 1 and 200 or -200
end

function Ball:render()
    love.graphics.circle('fill', self.x, self.y, self.r) 
end