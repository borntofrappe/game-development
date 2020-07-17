Paddle = {}

function Paddle:init(cx, cy)
    paddle = {}

    paddle.cx = cx
    paddle.cy = cy
    paddle.r = 40
    paddle.speed = 300

    paddle.points = 5
    
    paddle.dx = 0
    paddle.dr = 5
    paddle.dspeed = 20

    paddle.is_ready = false

    self.__index = self
    setmetatable(paddle, self)

    return paddle
end

function Paddle:reset(dt)
    self.r = 35
    self.points = 5
    self:wait()
end

function Paddle:ready()
    sounds['select']:play()
    self.is_ready = true
end

function Paddle:wait()
    self.is_ready = false
end

function Paddle:score()
    self.points = self.points - 1
    self.r = self.r - self.dr
    self.speed = self.speed - self.dspeed
end

function Paddle:win()
    sounds['victory']:play()
    self.r = 0
end

function Paddle:update(dt)
    if self.dx > 0 then
        self.cx = math.min(WINDOW_WIDTH - self.r, self.cx + self.dx * dt)
    elseif self.dx < 0 then
        self.cx = math.max(self.r, self.cx + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.circle('fill', self.cx, self.cy, self.r)
end