Powerup = Class {}

local POWERUP_WIDTH = 16
local POWERUP_HEIGHT = 16
local POWERUP_DEFAULT = 9
local POWERUP_DY_MIN = 40
local POWERUP_DY_MAX = 80

function Powerup:init(x, y, powerup)
  self.x = x - POWERUP_WIDTH / 2
  self.y = y - POWERUP_HEIGHT / 2
  self.startingY = self.y
  self.powerup = powerup or POWERUP_DEFAULT
  self.width = POWERUP_WIDTH
  self.height = POWERUP_HEIGHT
  self.dy = math.random(POWERUP_DY_MIN, POWERUP_DY_MAX)

  self.inPlay = false
end

function Powerup:update(dt)
  if self.inPlay then
    self.y = self.y + self.dy * dt
  end

  if self.y > VIRTUAL_HEIGHT then
    self.inPlay = false
    self.y = self.startingY
  end
end

function Powerup:render()
  if self.inPlay then
    love.graphics.draw(gTextures["breakout"], gFrames["powerups"][self.powerup], self.x, self.y)
  end
end
