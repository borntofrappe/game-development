Character = Class {}

function Character:init(x, y)
  self.x = x
  self.y = y
  self.width = CHARACTER_WIDTH
  self.height = CHARACTER_HEIGHT

  self.movementSpeed = CHARACTER_MOVEMENT_SPEED
  self.jumpSpeed = CHARACTER_JUMP_SPEED

  self.dy = 0
  self.jumping = false

  self.idleAnimation =
    Animation(
    {
      frames = {1},
      interval = 1
    }
  )

  self.movingAnimation =
    Animation(
    {
      frames = {10, 11},
      interval = 0.2
    }
  )

  self.jumpingAnimation =
    Animation(
    {
      frames = {3},
      interval = 0.3
    }
  )

  self.currentAnimation = self.idleAnimation
  self.direction = "right"
end

function Character:update(dt)
  self.currentAnimation:update(dt)

  if self.jumping then
    self.dy = self.dy + GRAVITY
    self.y = self.y + self.dy * dt
  end

  if self.y > TILE_SIZE * (ROWS_SKY - 1) - self.height then
    self.y = TILE_SIZE * (ROWS_SKY - 1) - self.height
    self.dy = 0
    self.jumping = false
    self.currentAnimation = self.idleAnimation
  end
end

function Character:render()
  love.graphics.draw(
    gTextures["character"],
    gFrames["character"][self.currentAnimation:getCurrentFrame()],
    self.direction == "right" and math.floor(self.x) or math.floor(self.x + self.width),
    math.floor(self.y),
    0,
    self.direction == "right" and 1 or -1,
    1
  )
end

function Character:jump()
  self.jumping = true
  self.dy = -self.jumpSpeed
  self.currentAnimation = self.jumpingAnimation
end

function Character:move(direction, dt)
  self.direction = direction
  if self.direction == "right" then
    self.x = math.min(MAP_WIDTH * TILE_SIZE - self.width, self.x + self.movementSpeed * dt)
  else
    self.x = math.max(0, self.x - self.movementSpeed * dt)
  end

  if not self.jumping then
    self.currentAnimation = self.movingAnimation
  end
end

function Character:idle()
  if not self.jumping then
    self.currentAnimation = self.idleAnimation
  end
end
