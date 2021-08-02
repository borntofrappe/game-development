StartState = BaseState:new()

function StartState:enter()
  self.title = {
    ["text"] = TITLE,
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight() - 12
  }

  local menu = {
    ["text"] = "Play",
    ["y"] = self.title.y + gFonts.large:getHeight() + 44,
    ["hasFocus"] = false
  }

  menu.buttonWidth = gFonts.normal:getWidth(menu.text) * 1.75
  menu.buttonHeight = gFonts.normal:getHeight() * 1.25
  menu.buttonY = menu.y + gFonts.normal:getHeight() / 2 - menu.buttonHeight / 2
  menu.buttonX = WINDOW_WIDTH / 2 - menu.buttonWidth / 2

  self.menu = menu
end

function StartState:update(dt)
  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    if
      x > self.menu.buttonX and x < self.menu.buttonX + self.menu.buttonWidth and y > self.menu.buttonY and
        y < self.menu.buttonY + self.menu.buttonHeight
     then
      self.menu.hasFocus = true
    else
      self.menu.hasFocus = false
    end
  end

  if love.mouse.waspressed(1) and self.menu.hasFocus then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  if self.menu.hasFocus then
    love.graphics.rectangle(
      "fill",
      self.menu.buttonX - 2,
      self.menu.buttonY - 2,
      self.menu.buttonWidth + 4,
      self.menu.buttonHeight + 4,
      10
    )
    love.graphics.setColor(0.18, 0.18, 0.19)
  else
    love.graphics.setLineWidth(4)
    love.graphics.rectangle(
      "line",
      self.menu.buttonX,
      self.menu.buttonY,
      self.menu.buttonWidth,
      self.menu.buttonHeight,
      10
    )
  end

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.menu.text, 0, self.menu.y, WINDOW_WIDTH, "center")
end
