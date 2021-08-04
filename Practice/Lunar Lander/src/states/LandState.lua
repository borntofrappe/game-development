LandState = BaseState:new()

function LandState:enter(params)
  self.lander = params.lander
  self.data = params.data
end

function LandState:update(dt)
  if love.keyboard.waspressed("return") or love.keyboard.waspressed("escape") then
    self.lander.body:destroy()

    gTerrain = getTerrain()
    gStateMachine:change("start")
  end
end

function LandState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.small)
  for _, data in pairs(self.data) do
    love.graphics.print(data.format(data.value):upper(), data.x, data.y)
  end

  love.graphics.setLineWidth(2)
  love.graphics.circle("line", self.lander.body:getX(), self.lander.body:getY(), self.lander.core.shape:getRadius())
  for _, gear in pairs(self.lander.landingGear) do
    love.graphics.polygon("line", self.lander.body:getWorldPoints(gear.shape:getPoints()))
  end

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Landed!", 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")
end
