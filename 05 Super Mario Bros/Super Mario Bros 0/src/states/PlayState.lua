PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.background = math.random(#gFrames.backgrounds)
  self.variety_tiles = math.random(#gFrames.tiles)
  self.variety_tops = math.random(#gFrames.tops)

  self.player = Player(VIRTUAL_WIDTH / 2 - PLAYER_WIDTH / 2, TILE_SIZE * (ROWS_SKY - 1) - PLAYER_HEIGHT)
  self.cameraScroll = 0

  self.level = LevelMaker.generate(MAP_WIDTH, MAP_HEIGHT)
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("r") then
    self.background = math.random(#gFrames.backgrounds)
    self.variety_tiles = math.random(#gFrames.tiles)
    self.variety_tops = math.random(#gFrames.tops)
  end

  if love.keyboard.waspressed("space") then
    if not self.player.jumping then
      self.player:jump()
    end
  end

  self.player:update(dt)

  if love.keyboard.isDown("right") then
    self.player:move("right", dt)
  elseif love.keyboard.isDown("left") then
    self.player:move("left", dt)
    self.direction = "left"
  else
    self.player:idle()
  end

  self:updateCamera()
end

function PlayState:render()
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.background], 0, 0)
  love.graphics.translate(-math.floor(self.cameraScroll), 0)
  love.graphics.setColor(1, 1, 1, 1)

  for x, column in ipairs(self.level) do
    for y, tile in ipairs(column) do
      love.graphics.draw(
        gTextures["tiles"],
        gFrames["tiles"][self.variety_tiles][tile.id],
        (x - 1) * TILE_SIZE,
        (y - 1) * TILE_SIZE
      )
      if tile.topper then
        love.graphics.draw(
          gTextures["tops"],
          gFrames["tops"][self.variety_tops][1],
          (x - 1) * TILE_SIZE,
          (y - 1) * TILE_SIZE
        )
      end
    end
  end

  self.player:render()
end

function PlayState:updateCamera()
  self.cameraScroll =
    math.max(
    0,
    math.min(MAP_WIDTH * TILE_SIZE - VIRTUAL_WIDTH, self.player.x + self.player.width / 2 - VIRTUAL_WIDTH / 2)
  )
end
