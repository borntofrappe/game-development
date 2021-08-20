StopState = BaseState:new()

local TWEEN_ANIMATION = 2

function StopState:enter(params)
  self.tilesBonus = params.tilesBonus
  self.tilesFinishLine = params.tilesFinishLine
  self.tilesOffset = params.tilesOffset
  self.car = params.car
  self.cars = params.cars

  Timer:tween(
    TWEEN_ANIMATION,
    {
      [self.tilesOffset] = {["speed"] = 0}
    }
  )

  for k, car in pairs(self.cars) do
    Timer:tween(
      TWEEN_ANIMATION,
      {
        [car] = {["speed"] = 0}
      }
    )
  end
end

function StopState:update(dt)
  Timer:update(dt)

  if self.tilesOffset.speed > 0 then
    self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt

    for k, car in pairs(self.cars) do
      car.x = car.x + (car.speed - self.tilesOffset.speed) * dt
    end
  end

  if love.keyboard.waspressed("escape") then
    Timer:reset()
    gStateMachine:change("start")
  end
end

function StopState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1 + VIRTUAL_WIDTH, 0)
  self.tilesBonus:render()
  for k, tile in pairs(self.tilesFinishLine) do
    tile:render()
  end
  love.graphics.pop()

  for k, car in pairs(self.cars) do
    car:render()
  end

  self.car:render()
end
