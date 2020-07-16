Ball = {}

function randomDX()
    return math.random(-170, 170)
end

function randomDY()
    dy = math.random(100, 200)
    return math.random(2) == 1 and dy or dy * -1
end


function Ball:init(x, y, r)
    ball = {}

    ball.x = x
    ball.y = y
    ball.r = r

    ball.dx = randomDX()
    ball.dy = randomDY()

    self.__index = self
    setmetatable(ball, self)
    return ball
end


function Ball:update(dt)
    self.x = self.x + dt * self.dx
    self.y = self.y + dt * self.dy

    if self.x < self.r then
        sounds["bounce"]:play()
        self.x = self.r
        self.dx = self.dx * -1
    
    elseif self.x > WINDOW_WIDTH - self.r then
        sounds["bounce"]:play()
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
    x = paddle.x
    y = paddle.y
    r = paddle.r
    
    self.x = self.x > x and self.x + self.r / 2 or self.x - self.r / 2
    self.y = self.dy > 0 and self.y - self.r / 2 or self.y + self.r / 2

    if self.x > x then
        self.dx = math.abs(randomDX())
    else
        self.dx = -math.abs(randomDX())
    end
    
    self.dy = self.dy * -1.1
end


function Ball:reset(direction)
    ball.dx = randomDX()
    dy = randomDY()
    if direction then
        dy = direction == 'top' and math.abs(dy) or -math.abs(dy)
    end
    ball.dy = dy

    ball.x = WINDOW_WIDTH / 2
    ball.y = WINDOW_HEIGHT / 2
end


function Ball:render()
    love.graphics.circle('fill', self.x, self.y, self.r) 
end