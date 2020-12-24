Player = Class {}

function Player:init(x, y)
  self.x = x
  self.y = y
  self.width = CHARACTER_WIDTH
  self.height = CHARACTER_HEIGHT

  self.dy = 0
  self.isJumping = false

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

function Player:render()
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
