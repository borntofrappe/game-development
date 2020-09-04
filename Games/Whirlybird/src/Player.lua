Player = Class {}

function Player:init(x, y)
  self.width = PLAYER_WIDTH
  self.height = PLAYER_HEIGHT
  self.x = x
  self.y = y
  self.variety = 1
  self.varieties = {1}

  self.direction = 1
  self.dx = 0
  self.dy = 0

  self.timer = 0
  self.interval = 0.1
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

  if #self.varieties > 1 then
    self.timer = self.timer + dt
    if self.timer > self.interval then
      self.timer = self.timer % self.interval
      if self.variety == #self.varieties then
        self.variety = 1
      else
        self.variety = self.variety + 1
      end
    end
  end
end

function Player:render()
  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["player"][self.varieties[self.variety]],
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
  self.variety = 1

  if state == "flying" then
    self.varieties = {2, 3, 4}
    width = PLAYER_FLYING_WIDTH
    height = PLAYER_FLYING_HEIGHT
  elseif state == "falling" then
    self.varieties = {5, 6}
    width = PLAYER_FALLING_WIDTH
    height = PLAYER_FALLING_HEIGHT
  else
    self.varieties = {1}
  end

  self.x = self.x + (self.width - width)
  self.y = self.y + (self.height - height)
  self.width = width
  self.height = height
end
