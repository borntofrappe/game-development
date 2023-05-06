Paddle = Class{}

function Paddle:getScope()
    return math.random(PADDLE.scope.min, PADDLE.scope.max)
end

function Paddle:init(x, y)
    self.x = x 
    self.y = y
    self.width = PADDLE.width 
    self.height = PADDLE.height
    self.dx = 0
    self.looksAhead = false 
    self.scope = self:getScope()
    self.aim = x
end

function Paddle:target(puck)
    self.aim = puck.x + puck.dx * math.abs(self.y + self.height / 2 - puck.y) / math.abs(puck.dy)
    self.scope = self:getScope()
    self.looksAhead = false
end

function Paddle:update(dt)
    if self.x > self.aim then 
        self.dx = PADDLE.speed * -1
    elseif self.x + self.width < self.aim then
        self.dx = PADDLE.speed
    else
        self.dx = 0
    end

    self.x = math.max(0, math.min(WINDOW.width - self.width, self.x + self.dx * dt))
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end