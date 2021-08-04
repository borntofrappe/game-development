LandState = BaseState:new()

function LandState:enter(params)
  self.lander = params.lander
  self.data = params.data

  self.data.metrics.score.value = self.data.metrics.score.value + 100
  self.data.metrics.fuel.value = self.data.metrics.fuel.value + 200
end

function LandState:update(dt)
  if love.keyboard.waspressed("escape") then
    self.lander.body:destroy()

    gTerrain = getTerrain()

    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    self.lander.body:destroy()

    gTerrain = getTerrain()

    gStateMachine:change(
      "play",
      {
        ["data"] = self.data
      }
    )
  end
end

function LandState:render()
  self.data:render()
  self.lander:render()

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Landed!", 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")
end
