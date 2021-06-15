Ball = Class {}

local BALL_DX_MIN = 60
local BALL_DX_MAX = 100
local BALL_DY_MIN = 60
local BALL_DY_MAX = 120
local BALL_COLORS = 7

function Ball:init(x, y)
  self.x = x
  self.y = y
  self.width = BALL_WIDTH
  self.height = BALL_HEIGHT

  self.dx = math.random(2) == 1 and math.random(BALL_DX_MIN, BALL_DX_MAX) or math.random(BALL_DX_MIN, BALL_DX_MAX) * -1
  self.dy = math.random(BALL_DY_MIN, BALL_DY_MAX) * -1

  self.color = math.random(BALL_COLORS)
end

function Ball:collides(shape)
  if self.x + self.width < shape.x or self.x > shape.x + shape.width then
    return false
  end

  if self.y + self.height < shape.y or self.y > shape.y + shape.height then
    return false
  end

  return true
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x <= 0 then
    self.x = 0
    self.dx = self.dx * -1
    gSounds["wall_hit"]:play()
  end

  if self.x >= VIRTUAL_WIDTH - self.width then
    self.x = VIRTUAL_WIDTH - self.width
    self.dx = self.dx * -1
    gSounds["wall_hit"]:play()
  end

  if self.y <= 0 then
    self.y = 0
    self.dy = self.dy * -1
    gSounds["wall_hit"]:play()
  end
end

function Ball:render()
  love.graphics.draw(gTextures["breakout"], gFrames["balls"][self.color], self.x, self.y)
end
