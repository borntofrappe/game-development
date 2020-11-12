PlatformState = Class({__includes = BaseState})

function PlatformState:enter(def)
  self.terrain = def.terrain
  self.data = def.data
end

function PlatformState:update(dt)
  if love.keyboard.wasPressed("return") then
    gStateMachine:change(
      "orbit",
      {
        terrain = self.terrain,
        data = self.data
      }
    )
  end
end

function PlatformState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)

  love.graphics.line(self.terrain)

  displayData(self.data)

  love.graphics.printf("Platform State", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
