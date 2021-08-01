StartState = BaseState:new()

function StartState:enter()
  self.title = {
    ["text"] = "Side Pocket",
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight() - 12
  }

  local menu = {
    ["text"] = "Play",
    ["y"] = self.title.y + gFonts.large:getHeight() + 44
  }

  menu.width = gFonts.normal:getWidth(menu.text)
  menu.height = gFonts.normal:getHeight()

  self.menu = menu
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setLineWidth(6)
  love.graphics.rectangle(
    "line",
    WINDOW_WIDTH / 2 - self.menu.width,
    self.menu.y - self.menu.height / 2 + 1,
    self.menu.width * 2,
    self.menu.height * 2,
    10
  )

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.menu.text, 0, self.menu.y, WINDOW_WIDTH, "center")
end
