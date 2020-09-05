PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.variety_backgrounds = math.random(#gFrames.backgrounds)
  self.variety_tiles = math.random(#gFrames.tiles)
  self.variety_tops = math.random(#gFrames.tops)

  self.character = Character(VIRTUAL_WIDTH / 2 - CHARACTER_WIDTH / 2, TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT)
  self.cameraScroll = 0

  self.tiles = GenerateLevel(MAP_WIDTH, MAP_HEIGHT)
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("r") then
    self.variety_backgrounds = math.random(#gFrames.backgrounds)
    self.variety_tiles = math.random(#gFrames.tiles)
    self.variety_tops = math.random(#gFrames.tops)
  end

  if love.keyboard.waspressed("space") then
    if not self.character.jumping then
      self.character:jump()
    end
  end

  self.character:update(dt)

  if love.keyboard.isDown("right") then
    self.character:move("right", dt)
  elseif love.keyboard.isDown("left") then
    self.character:move("left", dt)
    self.direction = "left"
  else
    self.character:idle()
  end

  self.cameraScroll =
    math.max(
    0,
    math.min(MAP_WIDTH * TILE_SIZE - VIRTUAL_WIDTH, self.character.x + self.character.width / 2 - VIRTUAL_WIDTH / 2)
  )
end

function PlayState:render()
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.variety_backgrounds], 0, 0)
  love.graphics.translate(-math.floor(self.cameraScroll), 0)
  love.graphics.setColor(1, 1, 1, 1)

  for x, column in ipairs(self.tiles) do
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

  self.character:render()
end
