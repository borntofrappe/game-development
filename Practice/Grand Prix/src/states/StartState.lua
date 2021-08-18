StartState = BaseState:new()

function StartState:enter()
  local tiles = {}
  local tilesBackground = 1
  local tilesEdge = 1
  local tilesRoad = ROWS - tilesBackground * 2 - tilesEdge * 2

  local tileSize = TILE_SIZE.texture

  for column = 1, COLUMNS do
    for row = 1, ROWS do
      local x = (column - 1) * tileSize
      local y = (row - 1) * tileSize
      local id = 2
      if row == 1 or row == ROWS then
        id = 1
      elseif row == 2 or row == ROWS - 1 then
        id = 4
      end

      table.insert(
        tiles,
        {
          ["x"] = x,
          ["y"] = y,
          ["id"] = id
        }
      )
    end
  end

  self.tiles = tiles

  self.title = {
    ["text"] = string.upper("Grand Prix"),
    ["y"] = VIRTUAL_HEIGHT / 4 - gFonts.normal:getHeight() / 2
  }

  local carSize = TILE_SIZE.car
  local car = {
    ["x"] = VIRTUAL_WIDTH / 2 - carSize / 2,
    ["y"] = VIRTUAL_HEIGHT / 2 - carSize / 2,
    ["color"] = 1
  }

  local frames = {}
  for i = 1, #gQuads.cars[1] do
    table.insert(frames, i)
  end
  car.animation = Animation:new(frames, 0.1)

  self.car = car
end

function StartState:update(dt)
  self.car.animation:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("right") then
    self.car.color = self.car.color == #gQuads["cars"] and 1 or self.car.color + 1
  end

  if love.keyboard.waspressed("left") then
    self.car.color = self.car.color == 1 and #gQuads["cars"] or self.car.color - 1
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)

  for k, tile in pairs(self.tiles) do
    love.graphics.draw(gTextures["spritesheet"], gQuads["textures"][tile.id], tile.x, tile.y)
  end

  love.graphics.draw(
    gTextures["spritesheet"],
    gQuads["cars"][self.car.color][self.car.animation:getCurrentFrame()],
    self.car.x,
    self.car.y
  )

  love.graphics.setFont(gFonts.normal)
  love.graphics.setColor(0.06, 0.07, 0.19)
  love.graphics.setColor(0.2, 0.21, 0.36)
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts.small)
  love.graphics.printf("Press enter", 0, VIRTUAL_HEIGHT * 3 / 4 - gFonts.small:getHeight(), VIRTUAL_WIDTH, "center")
end
