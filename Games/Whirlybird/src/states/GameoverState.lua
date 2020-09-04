GameoverState = Class({__includes = BaseState})

function GameoverState:init()
  self.text = "Game\nOver"

  self.button = {
    x = WINDOW_WIDTH / 2 - BUTTON_WIDTH / 2,
    y = WINDOW_HEIGHT / 4 * 3 + 24,
    width = BUTTON_WIDTH,
    height = BUTTON_HEIGHT
  }

  self.variety = 1
  self.varieties = #gFrames["sprites"][1]
  self.timer = 0
  self.interval = 0.1
end

function GameoverState:enter(params)
  self.score = params.score
  if self.score > gRecord then
    gRecord = self.score
  end
end

function GameoverState:update(dt)
  self.timer = self.timer + dt
  if self.timer > self.interval then
    self.timer = self.timer % self.interval
    if self.variety == self.varieties then
      self.variety = 1
    else
      self.variety = self.variety + 1
    end
  end
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gStateMachine:change("play", {})
  end

  if love.mouse.isDown(1) then
    x, y = love.mouse.getPosition()
    if
      x > self.button.x and x < self.button.x + self.button.width and y > self.button.y and
        y < self.button.y + self.button.height
     then
      gStateMachine:change("play", {})
    end
  end
end

function GameoverState:render()
  love.graphics.setColor(gColors["grey"]["r"], gColors["grey"]["g"], gColors["grey"]["b"])
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT / 3 - 56 - 48, WINDOW_WIDTH, "center")

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(
    gTextures["spritesheet-gameover"],
    gFrames["checks"][1],
    math.floor(WINDOW_WIDTH / 2 - 16 - CHECKS_WIDTH - (SPRITE_WIDTH - CHECKS_WIDTH) / 2),
    math.floor(WINDOW_HEIGHT / 3 + 42)
  )

  love.graphics.draw(
    gTextures["spritesheet-gameover"],
    gFrames["checks"][2],
    math.floor(WINDOW_WIDTH / 2 + 16 + (SPRITE_WIDTH - CHECKS_WIDTH) / 2),
    math.floor(WINDOW_HEIGHT / 3 + 42)
  )

  love.graphics.draw(
    gTextures["spritesheet-gameover"],
    gFrames["sprites"][1][self.variety],
    math.floor(WINDOW_WIDTH / 2 - 16 - SPRITE_WIDTH),
    math.floor(WINDOW_HEIGHT / 3 + 42 + 32 + CHECKS_HEIGHT)
  )

  love.graphics.draw(
    gTextures["spritesheet-gameover"],
    gFrames["sprites"][2][self.variety],
    math.floor(WINDOW_WIDTH / 2 + 16),
    math.floor(WINDOW_HEIGHT / 3 + 42 + 32 + CHECKS_HEIGHT)
  )

  love.graphics.draw(
    gTextures["spritesheet-gameover"],
    gFrames["button"],
    math.floor(self.button.x),
    math.floor(self.button.y)
  )

  showScore(self.score)
end
