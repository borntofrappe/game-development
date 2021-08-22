TitleState = BaseState:new()

function TitleState:enter(params)
  self.title = {
    ["text"] = string.upper(TITLE),
    ["x"] = 0,
    ["y"] = VIRTUAL_HEIGHT / 2 - gFonts.large:getHeight() / 2
  }

  self.tiles = Tiles:new()
  self.tilesOffset = 0

  self.car = params and params.car or Car:new(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 1)
  self.car.x = -self.car.size
  self.car.y = VIRTUAL_HEIGHT / 2 - self.car.size / 2
end

function TitleState:update(dt)
  Timer:update(dt)

  self.tilesOffset = self.tilesOffset + OFFSET_SPEED_DEFAULT * dt
  if self.tilesOffset >= VIRTUAL_WIDTH then
    self.tilesOffset = self.tilesOffset % VIRTUAL_WIDTH
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "ready",
      {
        ["title"] = self.title,
        ["tiles"] = self.tiles,
        ["tilesOffset"] = self.tilesOffset,
        ["car"] = self.car
      }
    )
  end
end

function TitleState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset * -1, 0)
  self.tiles:render()
  love.graphics.pop()

  love.graphics.setFont(gFonts.large)
  love.graphics.setColor(0.06, 0.07, 0.19)
  love.graphics.printf(self.title.text, self.title.x, self.title.y, VIRTUAL_WIDTH, "center")
end
