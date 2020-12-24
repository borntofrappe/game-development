PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.width = 100
  self.height = 10
  self.map = LevelMaker.generate(self.width, self.height)
  self.background = math.random(#gFrames.backgrounds)
  self.tileset = math.random(#gFrames.tiles)
  self.topperset = math.random(#gFrames.tops)

  self.camX = 0
  self.camY = 0

  self.player = Player(VIRTUAL_WIDTH / 2 - CHARACTER_WIDTH / 2, TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT)
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("start")
  end

  self.player.currentAnimation:update(dt)

  if love.keyboard.wasPressed("space") and not self.player.isJumping then
    self.player.isJumping = true
    self.player.dy = -CHARACTER_JUMP_SPEED
    self.player.currentAnimation = self.player.jumpingAnimation
  end

  if love.keyboard.isDown("right") then
    self.player.x = math.min(self.width * TILE_SIZE - self.player.width, self.player.x + CHARACTER_MOVEMENT_SPEED * dt)
    self.player.direction = "right"
    if not self.player.isJumping then
      self.player.currentAnimation = self.player.movingAnimation
    end
  elseif love.keyboard.isDown("left") then
    self.player.x = math.max(0, self.player.x - CHARACTER_MOVEMENT_SPEED * dt)
    self.player.direction = "left"
    if not self.player.isJumping then
      self.player.currentAnimation = self.player.movingAnimation
    end
  else
    if not self.player.isJumping then
      self.player.currentAnimation = self.player.idleAnimation
    end
  end

  self.camX =
    math.max(
    0,
    math.min(self.width * TILE_SIZE - VIRTUAL_WIDTH, self.player.x + self.player.width / 2 - VIRTUAL_WIDTH / 2)
  )

  if self.player.isJumping then
    self.player.dy = self.player.dy + GRAVITY
    self.player.y = self.player.y + self.player.dy * dt
  end

  if self.player.y > TILE_SIZE * (ROWS_SKY - 1) - self.player.height then
    self.player.y = TILE_SIZE * (ROWS_SKY - 1) - self.player.height
    self.player.dy = 0
    self.player.isJumping = false
    self.player.currentAnimation = self.player.idleAnimation
  end
end

function PlayState:render()
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.background], 0, 0)

  love.graphics.translate(-math.floor(self.camX), 0)

  for x, column in ipairs(self.map) do
    for y, tile in ipairs(column) do
      love.graphics.draw(
        gTextures["tiles"],
        gFrames["tiles"][self.tileset][tile.id],
        (x - 1) * TILE_SIZE,
        (y - 1) * TILE_SIZE
      )
      if tile.topper then
        love.graphics.draw(
          gTextures["tops"],
          gFrames["tops"][self.topperset][1],
          (x - 1) * TILE_SIZE,
          (y - 1) * TILE_SIZE
        )
      end
    end
  end

  self.player:render()
end
