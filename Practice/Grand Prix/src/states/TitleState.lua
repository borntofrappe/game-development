TitleState = BaseState:new()

local DELAY_READY_STATE = 2

function TitleState:enter()
  self.title = {
    ["text"] = string.upper("Grand Prix"),
    ["y"] = VIRTUAL_HEIGHT / 2 - gFonts.large:getHeight() / 2
  }

  self.tiles = Tiles:new()
  self.tilesOffset = 0

  Timer:after(
    DELAY_READY_STATE,
    function()
      gStateMachine:change(
        "ready",
        {
          ["title"] = self.title,
          ["tiles"] = self.tiles,
          ["tilesOffset"] = self.tilesOffset
        }
      )
    end
  )
end

function TitleState:update(dt)
  Timer:update(dt)

  self.tilesOffset = self.tilesOffset + OFFSET_SPEED * dt
  if self.tilesOffset >= VIRTUAL_WIDTH then
    self.tilesOffset = self.tilesOffset % VIRTUAL_WIDTH
  end

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:reset()
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
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")
end
