Paddle = Class {}

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
    self.points = 0
end

function Paddle:score(increment)
    self.points = self.points + increment
end

function Paddle:target(puck)
    self.aim =
        (puck.x + puck.width / 2) +
        puck.dx * math.abs(self.y + self.height / 2 - puck.y + puck.height / 2) / math.abs(puck.dy)
    if self.aim > self.x then
        self.aim = self.aim + self.width / 2
    else
        self.aim = self.aim - self.width / 2
    end
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
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
