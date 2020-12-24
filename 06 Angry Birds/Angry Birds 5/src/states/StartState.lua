StartState = Class({__includes = BaseState})

function StartState:init()
  self.color = math.random(#gFrames["aliens"])
  self.variety = math.random(#gFrames["aliens"][self.color])
end

function StartState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") or love.mouse.wasPressed(1) then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("StartState", 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, "center")

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures["aliens"],
    gFrames["aliens"][self.color][self.variety],
    math.floor(VIRTUAL_WIDTH / 2 - ALIEN_WIDTH / 2),
    math.floor(VIRTUAL_HEIGHT / 2 + 24)
  )
end
