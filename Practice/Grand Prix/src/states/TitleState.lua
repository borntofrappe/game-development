TitleState = BaseState:new()

function TitleState:enter()
  self.title = {
    ["text"] = string.upper(TITLE),
    ["x"] = 0,
    ["y"] = VIRTUAL_HEIGHT / 2 - gFonts.large:getHeight() / 2
  }

  self.tiles = Tiles:new()
  self.tilesOffset = 0
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
        ["tilesOffset"] = self.tilesOffset
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
