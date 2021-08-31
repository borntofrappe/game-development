PlayState = BaseState:new()

function PlayState:new(numberGems)
  local offset = {
    ["x"] = 8,
    ["y"] = 32
  }

  local tiles = Tiles:new()
  local columns = tiles.columns
  local rows = tiles.rows
  local cellSize = tiles.cellSize

  local treasure = Treasure:new(numberGems, columns, rows, cellSize)

  local underlay = love.graphics.newSpriteBatch(gTextures.spritesheet)
  for column = 1, tiles.columns do
    for row = 1, tiles.rows do
      underlay:add(gQuads.tiles[1], (column - 1) * cellSize, (row - 1) * cellSize)
    end
  end

  local selection = {
    ["column"] = love.math.random(tiles.columns),
    ["row"] = love.math.random(tiles.rows)
  }

  local hammer = Tool:new(141, 32, 27, 34, "hammer", "fill")
  local pickaxe = Tool:new(141, 70, 27, 34, "pickaxe", "outline")

  local progressBar = ProgressBar:new(8, 8, 160, 16)

  local this = {
    ["particleSystem"] = ParticleSystem:new(),
    ["camera"] = {
      ["offsets"] = GenerateOffsets(),
      ["index"] = 1,
      ["duration"] = 0.15
    },
    ["offset"] = offset,
    ["underlay"] = underlay,
    ["treasure"] = treasure,
    ["tiles"] = tiles,
    ["selection"] = selection,
    ["hammer"] = hammer,
    ["pickaxe"] = pickaxe,
    ["progressBar"] = progressBar
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayState:update(dt)
  self.particleSystem:update(dt)

  if love.keyboard.waspressed("escape") then
    gStateStack:push(
      TransitionState:new(
        {
          ["transitionStart"] = true,
          ["callback"] = function()
            gStateStack:pop() -- play state

            gStateStack:push(TitleState:new())

            gStateStack:push(
              TransitionState:new(
                {
                  ["transitionStart"] = false
                }
              )
            )
          end
        }
      )
    )
  end

  if love.keyboard.waspressed("up") then
    self.selection.row = math.max(1, self.selection.row - 1)
  elseif love.keyboard.waspressed("down") then
    self.selection.row = math.min(self.tiles.rows, self.selection.row + 1)
  end

  if love.keyboard.waspressed("right") then
    self.selection.column = math.min(self.tiles.columns, self.selection.column + 1)
  elseif love.keyboard.waspressed("left") then
    self.selection.column = math.max(1, self.selection.column - 1)
  end

  if love.keyboard.waspressed("h") or love.keyboard.waspressed("H") then
    self.hammer:select()
    self.pickaxe:deselect()
  end

  if love.keyboard.waspressed("p") or love.keyboard.waspressed("P") then
    self.hammer:deselect()
    self.pickaxe:select()
  end

  local x, y = push:toGame(love.mouse:getPosition())
  if
    x and y and x > self.offset.x and x < self.offset.x + self.tiles.columns * self.tiles.cellSize and y > self.offset.y and
      y < self.offset.y + self.tiles.rows * self.tiles.cellSize
   then
    local column = math.floor((x - self.offset.x) / self.tiles.cellSize) + 1
    local row = math.floor((y - self.offset.y) / self.tiles.cellSize) + 1
    self.selection.column = column
    self.selection.row = row
  end

  if love.mouse.waspressed(1) then
    local x, y = push:toGame(love.mouse:getPosition())

    if
      x > self.hammer.panel.x and x < self.hammer.panel.x + self.hammer.panel.width and y > self.hammer.panel.y and
        y < self.hammer.panel.y + self.hammer.panel.height
     then
      self.hammer:select()
      self.pickaxe:deselect()
    end

    if
      x > self.pickaxe.panel.x and x < self.pickaxe.panel.x + self.pickaxe.panel.width and y > self.pickaxe.panel.y and
        y < self.pickaxe.panel.y + self.pickaxe.panel.height
     then
      self.pickaxe:select()
      self.hammer:deselect()
    end
  end

  if
    love.keyboard.waspressed("return") or
      (love.mouse.waspressed(1) and x > self.offset.x and x < self.offset.x + self.tiles.columns * self.tiles.cellSize and
        y > self.offset.y and
        y < self.offset.y + self.tiles.rows * self.tiles.cellSize)
   then
    gStateStack:push(
      DigState:new(
        {
          ["state"] = self
        }
      )
    )
  end
end

function PlayState:render()
  love.graphics.setColor(0.292, 0.222, 0.155)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.push()
  love.graphics.translate(self.camera.offsets[self.camera.index], 0)

  self.progressBar:render()

  self.hammer:render()
  self.pickaxe:render()

  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)

  love.graphics.draw(self.underlay)

  self.treasure:render()

  self.tiles:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures.spritesheet,
    gQuads.selection,
    (self.selection.column - 1) * self.tiles.cellSize,
    (self.selection.row - 1) * self.tiles.cellSize
  )

  love.graphics.pop()

  self.particleSystem:render()

  love.graphics.pop()
end
