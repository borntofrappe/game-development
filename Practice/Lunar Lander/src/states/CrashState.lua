CrashState = BaseState:new()

function CrashState:enter(params)
  self.data = params.data
end

function CrashState:update(dt)
  if love.keyboard.waspressed("return") or love.keyboard.waspressed("escape") then
    gTerrain = getTerrain()
    gStateMachine:change("start")
  end
end

function CrashState:render()
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.small)
  for _, data in pairs(self.data) do
    love.graphics.print(data.format(data.value):upper(), data.x, data.y)
  end

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Crashed!", 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")
end
