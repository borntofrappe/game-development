PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.level = Level()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("select")
  end

  if love.keyboard.wasPressed("space") or love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self.level = Level()
  end
end

function PlayState:render()
  love.graphics.clear(0.05, 0.05, 0.05)

  love.graphics.setColor(0.9, 0.9, 0.95)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("PlayState", 0, WINDOW_HEIGHT - 8 - gFonts["normal"]:getHeight(), WINDOW_WIDTH, "center")

  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  self.level:render()
end
