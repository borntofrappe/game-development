StartState = Class({__includes = BaseState})

function StartState:init()
  self.width = 100
  self.height = 10
  self.level, self.objects = LevelMaker.generate(self.width, self.height)

  self.background = math.random(#gFrames.backgrounds)
end

function StartState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.background], 0, 0)

  self.level:render()

  for k, object in pairs(self.objects) do
    object:render()
  end

  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("Super Mario Bros.", 1, VIRTUAL_HEIGHT / 2 - 36 - 8 + 1, VIRTUAL_WIDTH, "center")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Super Mario Bros.", 0, VIRTUAL_HEIGHT / 2 - 36 - 8, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("Press Enter", 1, VIRTUAL_HEIGHT / 2 + 24 + 1, VIRTUAL_WIDTH, "center")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Press Enter", 0, VIRTUAL_HEIGHT / 2 + 24, VIRTUAL_WIDTH, "center")
end
