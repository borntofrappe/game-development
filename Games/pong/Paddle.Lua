Paddle = {}

function Paddle:init(x, y, r)
    paddle = {}

    paddle.x = x
    paddle.y = y
    paddle.r = r
    
    paddle.hasWon = false
    paddle.dx = 0
    
    paddle.points = 0

    self.__index = self
    setmetatable(paddle, self)
    return paddle
end


function Paddle:update(dt)
    if self.dx < 0 then
        self.x = math.max(-WINDOW_WIDTH / 2 + self.r, self.x + dt * self.dx)
    elseif self.dx > 0 then
        self.x = math.min(WINDOW_WIDTH / 2 - self.r, self.x + dt * self.dx)
    end
end


function Paddle:score(score)
    self.points = score and score or self.points + 1
end


function Paddle:render()
    love.graphics.arc('fill', self.x, self.y, self.r, math.pi, math.pi * 2) 
end
