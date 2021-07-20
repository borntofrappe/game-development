BonusInvader = {}

local MIN_POINTS = INVADER_TYPES * INVADER_POINTS_MULTIPLIER
local MAX_POINTS = MIN_POINTS * 4
local SPEED = 100

function BonusInvader:new()
  local direction = math.random(2) and 1 or -1
  local height = INVADER_BONUS_HEIGHT
  local width = INVADER_BONUS_WIDTH
  local y = WINDOW_PADDING + DATA_HEIGHT + PLAYING_AREA_BONUS_HEIGHT / 2 - height / 2
  local x = direction == 1 and -width or WINDOW_WIDTH

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["dx"] = direction * SPEED,
    ["points"] = math.random(MIN_POINTS, MAX_POINTS),
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function BonusInvader:update(dt)
  if self.inPlay then
    self.x = self.x + self.dx * dt

    if self.x < -self.width or self.x > WINDOW_WIDTH then
      self.inPlay = false
    end
  end
end

function BonusInvader:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["bonus-invader"], self.x, self.y)
end
