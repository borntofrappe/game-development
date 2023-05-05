Paddle = Class{}

function Paddle:init(x, y)
    self.x = x 
    self.y = y
    self.width = PADDLE.width 
    self.height = PADDLE.height
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end