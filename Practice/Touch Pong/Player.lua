require 'Paddle'

Player = Class{}

function Player:init(x, y)
  self.paddle = Paddle(x, y, PADDLE_RADIUS)
  self.points = 0
  self.ready = false
end

function Player:isReady()
  return self.ready
end

function Player:setReady(ready)
  self.ready = ready == nil and true or ready
end

function Player:score()
  self.points = self.points + 1

  self.paddle.innerRadius = self.paddle.r * self.points / VICTORY
end

function Player:hasWon()
  return self.points == VICTORY
end

function Player:reset() 
  self.paddle:reset()

  self.ready = false
  self.points = 0
end

function Player:stop()
  self.paddle.dx = 0
end

function Player:move(direction)
  self.paddle.dx = direction == 'right' and PADDLE_SPEED or PADDLE_SPEED * -1
end

function Player:update(dt)
  self.paddle:update(dt)
end

function Player:render()
  self.paddle:render()
end