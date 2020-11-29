StartState = BaseState:create()

function StartState:enter()
  self.title = "Surround"
  self.width = gFonts["big"]:getWidth(self.title)
  self.height = gFonts["big"]:getHeight()

  self.message = {
    ["text"] = "Press enter",
    ["alpha"] = 1
  }

  Timer:every(
    1,
    function()
      self.message.alpha = self.message.alpha == 1 and 0 or 1
    end
  )
end

function StartState:update(dt)
  Timer:update(dt)

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  elseif love.keyboard.wasPressed("return") then
    Timer:reset()
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf(self.title:upper(), 0, WINDOW_HEIGHT / 2 - self.height, WINDOW_WIDTH, "center")

  love.graphics.setColor(0.16, 0.83, 0.69, 0.5)
  love.graphics.rectangle(
    "fill",
    WINDOW_WIDTH / 2 - self.width / 2,
    WINDOW_HEIGHT / 2 - self.height - CELL_SIZE - 16,
    self.width - CELL_SIZE,
    CELL_SIZE
  )
  love.graphics.setColor(0.16, 0.83, 0.69)
  love.graphics.rectangle(
    "fill",
    WINDOW_WIDTH / 2 - self.width / 2 + self.width - CELL_SIZE,
    WINDOW_HEIGHT / 2 - self.height - CELL_SIZE - 16,
    CELL_SIZE,
    CELL_SIZE
  )

  love.graphics.setColor(0.62, 0, 1, 0.5)
  love.graphics.rectangle(
    "fill",
    WINDOW_WIDTH / 2 - self.width / 2 + CELL_SIZE,
    WINDOW_HEIGHT / 2 + 16,
    self.width - CELL_SIZE,
    CELL_SIZE
  )
  love.graphics.setColor(0.62, 0, 1)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - self.width / 2, WINDOW_HEIGHT / 2 + 16, CELL_SIZE, CELL_SIZE)

  love.graphics.setColor(0.3, 0.3, 0.3, self.message.alpha)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(self.message.text, 0, WINDOW_HEIGHT / 2 + self.height, WINDOW_WIDTH, "center")
end
