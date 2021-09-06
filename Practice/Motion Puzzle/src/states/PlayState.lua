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

  self.puzzle = Puzzle:new(1)

  self.offset = math.floor(WINDOW_SIZE - PUZZLE_SIZE) / 2
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.waspressed("right") then
    self.puzzle.frame = self.puzzle.frame == #gQuads.levels[self.puzzle.level] and 1 or self.puzzle.frame + 1
  end

  if love.keyboard.waspressed("left") then
    self.puzzle.frame = self.puzzle.frame == 1 and #gQuads.levels[self.puzzle.level] or self.puzzle.frame - 1
  end

  if love.keyboard.waspressed("up") or love.keyboard.waspressed("down") then
    local level = self.puzzle.level == 1 and 2 or 1
    self.puzzle = Puzzle:new(level)
  end
end

function PlayState:render()
  love.graphics.translate(self.offset, self.offset)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.border)

  self.puzzle:render()
end
