OrbitState = Class({__includes = BaseState})

function OrbitState:enter(def)
  self.terrain = def.terrain or makeTerrain()

  self.data =
    def.data or
    {
      ["score"] = 0,
      ["time"] = 0,
      ["fuel"] = 1000,
      ["altitude"] = 1000,
      ["horizontal speed"] = 0,
      ["vertical speed"] = 0
    }
end

function OrbitState:update(dt)
  if love.keyboard.wasPressed("return") then
    gStateMachine:change(
      "platform",
      {
        terrain = self.terrain,
        data = self.data
      }
    )
  end
end

function OrbitState:render()
  love.graphics.setColor(0.85, 0.85, 0.85)

  love.graphics.line(self.terrain)

  displayData(self.data)

  love.graphics.printf("Orbit State", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
