Ball = {}

function Ball:init(cx, cy, r)
    ball = {}

    ball.cx = cx
    ball.cy = cy
    ball.r = r

    ball.dx = math.random(-150, 150)
    dy = math.random(100, 200)
    ball.dy = math.random(2) == 1 and dy or dy * -1

    self.__index = self
    setmetatable(ball, self)

    return ball
end

function Ball:render()
    love.graphics.circle('fill', self.cx, self.cy, self.r)
end

function Ball:reset()
    self.cx = WINDOW_WIDTH / 2
    self.cy = WINDOW_HEIGHT / 2

    self.dx = math.random(-150, 150)
    dy = math.random(100, 200)
    self.dy = math.random(2) == 1 and dy or dy * -1
end

function Ball:update(dt)
    if self.cx > WINDOW_WIDTH - self.r or self.cx < self.r then
        self.dx = self.dx * -1.1
    end

    if self.cy < self.r or self.cy > WINDOW_HEIGHT - self.r then
        self:reset()
    end

    self.cx = self.cx + self.dx * dt
    self.cy = self.cy + self.dy * dt
end

function Ball:collides(paddle)
    return ((self.cx - paddle.cx) ^ 2 + (self.cy - paddle.cy) ^ 2) ^ 0.5 < paddle.r + self.r
end