StartState = BaseState:new()

function StartState:enter()
  self.title = {
    ["text"] = TITLE,
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight() - 12
  }

  local menu = {
    ["text"] = "Play",
    ["y"] = self.title.y + gFonts.large:getHeight() + 44
  }

  menu.buttonWidth = gFonts.normal:getWidth(menu.text) * 1.6
  menu.buttonHeight = gFonts.normal:getHeight() * 1.3
  menu.buttonY = menu.y + gFonts.normal:getHeight() / 2 - menu.buttonHeight / 2
  menu.buttonX = WINDOW_WIDTH / 2 - menu.buttonWidth / 2

  self.menu = menu
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end

  if love.mouse.waspressed(1) then
    local x, y = love.mouse:getPosition()
    if
      x > self.menu.buttonX and x < self.menu.buttonX + self.menu.buttonWidth and y > self.menu.buttonY and
        y < self.menu.buttonY + self.menu.buttonHeight
     then
      gStateMachine:change("play")
    end
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setLineWidth(4)
  love.graphics.rectangle(
    "line",
    self.menu.buttonX,
    self.menu.buttonY,
    self.menu.buttonWidth,
    self.menu.buttonHeight,
    10
  )

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.menu.text, 0, self.menu.y, WINDOW_WIDTH, "center")
end
