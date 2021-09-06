PlayState = BaseState:new()

function PlayState:enter()
  local border = love.graphics.newSpriteBatch(gTexture)
  local PUZZLE_DIMENSIONS = math.floor(PUZZLE_SIZE / TILE_SIZE)
  for dimension = -2, PUZZLE_DIMENSIONS + 1 do
    border:add(gQuads.tiles[1], (dimension) * TILE_SIZE, -TILE_SIZE * 2)
    border:add(gQuads.tiles[1], (dimension) * TILE_SIZE, (PUZZLE_DIMENSIONS + 1) * TILE_SIZE)
    border:add(gQuads.tiles[1], -TILE_SIZE * 2, (dimension) * TILE_SIZE)
    border:add(gQuads.tiles[1], (PUZZLE_DIMENSIONS + 1) * TILE_SIZE, (dimension) * TILE_SIZE)
  end
  self.border = border

  self.puzzle = Puzzle:new()

  self.offset = math.floor(WINDOW_SIZE - PUZZLE_SIZE) / 2

  self.frameDirection = 1
  Timer:every(
    0.75,
    function()
      self.puzzle.frame = self.puzzle.frame + self.frameDirection
      if self.puzzle.frame == self.puzzle.frames or self.puzzle.frame == 1 then
        self.frameDirection = self.frameDirection * -1
      end
    end
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()
    gStateMachine:change("title")
  end
end

function PlayState:render()
  love.graphics.translate(self.offset, self.offset)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.border)

  self.puzzle:render()
end
