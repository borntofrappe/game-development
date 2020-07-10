Paddle = {}

function Paddle:init(x, y, r, topHalf)
    paddle = {}

    paddle.x = x
    paddle.y = y
    paddle.r = r

    a1 = topHalf and math.pi or 0
    paddle.a1 = a1
    paddle.a2 = a1 + math.pi
    
    paddle.dx = 0
    
    paddle.points = 0
    paddle.hasWon = false
    paddle.isReady = false

    self.__index = self
    setmetatable(paddle, self)
    return paddle
end


function Paddle:update(dt)
    if self.dx < 0 then
        self.x = math.max(self.r, self.x + dt * self.dx)
    elseif self.dx > 0 then
        self.x = math.min(WINDOW_WIDTH - self.r, self.x + dt * self.dx)
    end
end


function Paddle:score(score)
    self.points = score and score or self.points + 1
end


function Paddle:render()
    love.graphics.arc('fill', self.x, self.y, self.r, self.a1, self.a2) 
end
