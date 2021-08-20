GameoverState = BaseState:new()

function GameoverState:enter(params)
  self.tilesBonus = params.tilesBonus
  self.tilesOffset = params.tilesOffset
  self.car = params.car
  self.cars = params.cars
  self.timer = params.timer
end

function GameoverState:update(dt)
  if love.keyboard.waspressed("escape") or love.keyboard.waspressed("return") then
    gStateMachine:change("start")
  end
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1 + VIRTUAL_WIDTH, 0)
  self.tilesBonus:render()
  love.graphics.pop()

  for k, car in pairs(self.cars) do
    car:render()
  end

  self.car:render()

  love.graphics.setFont(gFonts.large)
  love.graphics.setColor(0.06, 0.07, 0.19)
  love.graphics.printf(
    formatTimer(self.timer),
    0,
    VIRTUAL_HEIGHT / 4 - gFonts.large:getHeight() / 2,
    VIRTUAL_WIDTH,
    "center"
  )
end
