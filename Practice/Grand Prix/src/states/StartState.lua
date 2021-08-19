StartState = BaseState:new()

local DELAY_ANIMATION = 1
local TWEEN_ANIMATION = 1.2
local DELAY_READY = 0.2

local OFFSET_UPDATE_SPEED = 50

function StartState:enter()
  local columns = COLUMNS * 2 + 1
  local rows = ROWS

  local tiles = {}
  local tilesBackground = 1
  local tilesEdge = 1
  local tilesRoaROWSd = rows - tilesBackground * 2 - tilesEdge * 2

  local tileSize = TILE_SIZE.texture

  for column = 1, columns do
    for row = 1, rows do
      local x = (column - 1) * tileSize
      local y = (row - 1) * tileSize
      local id = 2
      if row == 1 or row == rows then
        id = 1
      elseif row == 2 or row == rows - 1 then
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
    ["y"] = VIRTUAL_HEIGHT / 4 - gFonts.large:getHeight() / 2
  }

  local carSize = TILE_SIZE.car
  local car = {
    ["x"] = -carSize,
    ["y"] = VIRTUAL_HEIGHT / 2 - carSize / 2,
    ["color"] = 1
  }

  local frames = {}
  for i = 1, #gQuads.cars[1] do
    table.insert(frames, i)
  end
  car.animation = Animation:new(frames, 0.1)

  self.car = car

  self.tilesOffset = 0
  self.isReady = false

  Timer:after(
    DELAY_ANIMATION,
    function()
      Timer:tween(
        TWEEN_ANIMATION,
        {
          [self.car] = {["x"] = VIRTUAL_WIDTH / 2 - carSize / 2}
        },
        function()
          Timer:after(
            DELAY_READY,
            function()
              self.isReady = true
            end
          )
        end
      )
    end
  )
end

function StartState:update(dt)
  Timer:update(dt)

  self.tilesOffset = self.tilesOffset + OFFSET_UPDATE_SPEED * dt
  if self.tilesOffset >= VIRTUAL_WIDTH then
    self.tilesOffset = self.tilesOffset % VIRTUAL_WIDTH
  end
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

  if love.keyboard.waspressed("return") and self.isReady then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset * -1, 0)
  for k, tile in pairs(self.tiles) do
    love.graphics.draw(gTextures["spritesheet"], gQuads["textures"][tile.id], tile.x, tile.y)
  end
  love.graphics.pop()

  love.graphics.draw(
    gTextures["spritesheet"],
    gQuads["cars"][self.car.color][self.car.animation:getCurrentFrame()],
    self.car.x,
    self.car.y
  )

  love.graphics.setFont(gFonts.large)
  love.graphics.setColor(0.06, 0.07, 0.19)
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")

  if self.isReady then
    love.graphics.setFont(gFonts.normal)
    love.graphics.printf("Ready", 0, VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight(), VIRTUAL_WIDTH, "center")
  end
end
