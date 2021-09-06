PlayState = BaseState:new()

function PlayState:enter(params)
  local border = love.graphics.newSpriteBatch(gTexture)
  local PUZZLE_DIMENSIONS = math.floor(PUZZLE_SIZE / TILE_SIZE)
  for dimension = -2, PUZZLE_DIMENSIONS + 1 do
    border:add(gQuads.tiles[1], (dimension) * TILE_SIZE, -TILE_SIZE * 2)
    border:add(gQuads.tiles[1], (dimension) * TILE_SIZE, (PUZZLE_DIMENSIONS + 1) * TILE_SIZE)
    border:add(gQuads.tiles[1], -TILE_SIZE * 2, (dimension) * TILE_SIZE)
    border:add(gQuads.tiles[1], (PUZZLE_DIMENSIONS + 1) * TILE_SIZE, (dimension) * TILE_SIZE)
  end
  self.border = border

  self.offset = math.floor(WINDOW_SIZE - PUZZLE_SIZE) / 2

  local level
  if params and params.previousLevel then
    repeat
      level = love.math.random(#gQuads.levels)
    until level ~= params.previousLevel
  end

  self.puzzle = Puzzle:new(level)

  self.frameDirection = 1
  Timer:every(
    0.7,
    function()
      self.puzzle.frame = self.puzzle.frame + self.frameDirection
      if self.puzzle.frame == self.puzzle.frames or self.puzzle.frame == 1 then
        self.frameDirection = self.frameDirection * -1
      end
    end
  )

  self.highlight = {
    ["column"] = love.math.random(self.puzzle.dimensions),
    ["row"] = love.math.random(self.puzzle.dimensions),
    ["frame"] = 1,
    ["label"] = "highlight"
  }

  self.selection = nil

  Timer:every(
    0.2,
    function()
      self.highlight.frame = self.highlight.frame == #gQuads.highlight and 1 or self.highlight.frame + 1
    end,
    false,
    self.highlight.label
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") or love.mouse.waspressed(2) then
    Timer:reset()
    gStateMachine:change("title")
  end

  if love.keyboard.waspressed("up") then
    self.highlight.row = math.max(1, self.highlight.row - 1)
  end

  if love.keyboard.waspressed("down") then
    self.highlight.row = math.min(self.puzzle.dimensions, self.highlight.row + 1)
  end

  if love.keyboard.waspressed("right") then
    self.highlight.column = math.min(self.puzzle.dimensions, self.highlight.column + 1)
  end

  if love.keyboard.waspressed("left") then
    self.highlight.column = math.max(1, self.highlight.column - 1)
  end

  if love.keyboard.waspressed("return") then
    self:handleSelection()
  end

  local x, y = love.mouse.getPosition()
  if x > self.offset and x < self.offset + PUZZLE_SIZE and y > self.offset and y < self.offset + PUZZLE_SIZE then
    local column = math.floor((x - self.offset) / PIECE_SIZE) + 1
    local row = math.floor((y - self.offset) / PIECE_SIZE) + 1
    self.highlight.column = column
    self.highlight.row = row

    if love.mouse.waspressed(1) then
      self:handleSelection()
    end
  end
end

function PlayState:handleSelection()
  if self.selection then
    if self.selection.column ~= self.highlight.column or self.selection.row ~= self.highlight.row then
      local c1 = self.selection.column
      local r1 = self.selection.row
      local c2 = self.highlight.column
      local r2 = self.highlight.row

      local key1 = GenerateKey(c1, r1)
      local key2 = GenerateKey(c2, r2)

      local c = self.puzzle.pieces[key1].column
      local r = self.puzzle.pieces[key1].row

      self.puzzle.pieces[key1].column = self.puzzle.pieces[key2].column
      self.puzzle.pieces[key1].row = self.puzzle.pieces[key2].row

      self.puzzle.pieces[key2].column = c
      self.puzzle.pieces[key2].row = r

      local isPuzzleComplete = true
      for k, piece in pairs(self.puzzle.pieces) do
        if piece.column ~= piece.position.column or piece.row ~= piece.position.row then
          isPuzzleComplete = false
          break
        end
      end
      if isPuzzleComplete then
        Timer:remove(self.highlight.label)
        gStateMachine:change(
          "congrats",
          {
            ["offset"] = self.offset,
            ["puzzle"] = self.puzzle
          }
        )
      end
    end
    self.selection = nil
  else
    self.selection = {
      ["column"] = self.highlight.column,
      ["row"] = self.highlight.row
    }
  end
end

function PlayState:render()
  love.graphics.translate(self.offset, self.offset)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.border)

  self.puzzle:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTexture,
    gQuads.highlight[self.highlight.frame],
    (self.highlight.column - 1) * PIECE_SIZE,
    (self.highlight.row - 1) * PIECE_SIZE
  )

  if self.selection then
    love.graphics.draw(
      gTexture,
      gQuads.selection[self.highlight.frame],
      (self.selection.column - 1) * PIECE_SIZE,
      (self.selection.row - 1) * PIECE_SIZE
    )
  end

  love.graphics.draw(
    gTexture,
    gQuads.pointer[self.highlight.frame],
    (self.highlight.column - 1) * PIECE_SIZE + math.floor(PIECE_SIZE / 2),
    (self.highlight.row - 1) * PIECE_SIZE + math.floor(PIECE_SIZE / 2)
  )
end
