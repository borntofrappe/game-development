PlayState = BaseState:new()

function PlayState:enter()
  local border = love.graphics.newSpriteBatch(gTexture)
  local PUZZLE_DIMENSIONS = math.floor(PUZZLE_SIZE / TILE_SIZE)
  for dimension = 0, PUZZLE_DIMENSIONS + 1 do
    border:add(gQuads.tiles[1], (dimension - 1) * TILE_SIZE, -TILE_SIZE)
    border:add(gQuads.tiles[1], (dimension - 1) * TILE_SIZE, PUZZLE_DIMENSIONS * TILE_SIZE)
    border:add(gQuads.tiles[1], -TILE_SIZE, (dimension - 1) * TILE_SIZE)
    border:add(gQuads.tiles[1], PUZZLE_DIMENSIONS * TILE_SIZE, (dimension - 1) * TILE_SIZE)
  end
  self.border = border

  self.offset = math.floor(WINDOW_SIZE - PUZZLE_SIZE) / 2
  self.level = 1
  self.frame = 1
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.waspressed("right") then
    self.frame = self.frame == #gQuads.levels[self.level] and 1 or self.frame + 1
  end

  if love.keyboard.waspressed("left") then
    self.frame = self.frame == 1 and #gQuads.levels[self.level] or self.frame - 1
  end

  if love.keyboard.waspressed("up") or love.keyboard.waspressed("down") then
    self.level = self.level == 1 and 2 or 1
    self.frame = 1
  end
end

function PlayState:render()
  love.graphics.translate(self.offset, self.offset)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.border)
  love.graphics.draw(gTexture, gQuads.levels[self.level][self.frame], 0, 0)
end
