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
    INTERVAL_DRAW,
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
    gSounds["select"]:stop()
    gSounds["select"]:play()
    Timer:reset()
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf(self.title:upper(), 0, WINDOW_HEIGHT / 2 - self.height, WINDOW_WIDTH, "center")

  love.graphics.setColor(COLORS.p1.r, COLORS.p1.g, COLORS.p1.b, OPACITY)
  love.graphics.rectangle(
    "fill",
    WINDOW_WIDTH / 2 - self.width / 2,
    WINDOW_HEIGHT / 2 - self.height - CELL_SIZE - 16,
    self.width - CELL_SIZE,
    CELL_SIZE
  )
  love.graphics.setColor(COLORS.p1.r, COLORS.p1.g, COLORS.p1.b)
  love.graphics.rectangle(
    "fill",
    WINDOW_WIDTH / 2 - self.width / 2 + self.width - CELL_SIZE,
    WINDOW_HEIGHT / 2 - self.height - CELL_SIZE - 16,
    CELL_SIZE,
    CELL_SIZE
  )

  love.graphics.setColor(COLORS.p2.r, COLORS.p2.g, COLORS.p2.b, OPACITY)
  love.graphics.rectangle(
    "fill",
    WINDOW_WIDTH / 2 - self.width / 2 + CELL_SIZE,
    WINDOW_HEIGHT / 2 + 16,
    self.width - CELL_SIZE,
    CELL_SIZE
  )
  love.graphics.setColor(COLORS.p2.r, COLORS.p2.g, COLORS.p2.b)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - self.width / 2, WINDOW_HEIGHT / 2 + 16, CELL_SIZE, CELL_SIZE)

  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b, self.message.alpha)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf(self.message.text, 0, WINDOW_HEIGHT / 2 + self.height, WINDOW_WIDTH, "center")
end
