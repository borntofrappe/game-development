Player = Class {}

function Player:init(x, y)
  self.width = PLAYER_WIDTH
  self.height = PLAYER_HEIGHT
  self.x = x
  self.y = y
  self.variety = 1

  self.direction = 1
  self.dx = 0
  self.dy = PLAYER_JUMP
end

function Player:update(dt)
  self.dy = self.dy + GRAVITY * dt
  self.y = self.y + self.dy

  if self.dx >= 0 then
    self.dx = self.dx - FRICTION * dt
    self.x = self.x + self.dx * self.direction
  end

  if self.x < -self.width then
    self.x = WINDOW_WIDTH
  end

  if self.x > WINDOW_WIDTH then
    self.x = -self.width
  end
end

function Player:render()
  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["player"][self.variety],
    self.direction == 1 and math.floor(self.x) or math.floor(self.x + self.width),
    math.floor(self.y),
    0,
    self.direction,
    1
  )
end

function Player:slide(direction)
  self.dx = PLAYER_SLIDE
  self.direction = direction == "right" and 1 or -1
end

function Player:bounce(type)
  local multiplier = type and type or 1
  self.dy = -PLAYER_JUMP * multiplier
end

function Player:change(state)
  local width = PLAYER_WIDTH
  local height = PLAYER_HEIGHT

  if state == "flying" then
    width = PLAYER_FLYING_WIDTH
    height = PLAYER_FLYING_HEIGHT
  elseif state == "falling" then
    width = PLAYER_FALLING_WIDTH
    height = PLAYER_FALLING_HEIGHT
  end

  self.x = self.x + (self.width - width)
  self.y = self.y + (self.height - height)
  self.width = width
  self.height = height
end
