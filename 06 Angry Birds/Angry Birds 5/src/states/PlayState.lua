PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.color = math.random(#gFrames["aliens"])
  self.variety = math.random(#gFrames["aliens"][self.color])
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") or love.mouse.wasPressed(2) then
    gStateMachine:change("start")
  end
end

function PlayState:render()
  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("PlayState", 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, "center")

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures["aliens"],
    gFrames["aliens"][self.color][self.variety],
    math.floor(VIRTUAL_WIDTH / 2 - ALIEN_WIDTH / 2),
    math.floor(VIRTUAL_HEIGHT / 2 + 24)
  )
end
