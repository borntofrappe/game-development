StopState = BaseState:new()

local TWEEN_ANIMATION = 2
local DELAY_WRAP_UP_STATE = 1

function StopState:enter(params)
  self.tilesBonus = params.tilesBonus
  self.tilesFinishLine = params.tilesFinishLine
  self.tilesOffset = params.tilesOffset
  self.car = params.car
  self.cars = params.cars
  self.timer = params.timer
  self.collisions = params.collisions

  Timer:tween(
    TWEEN_ANIMATION,
    {
      [self.tilesOffset] = {["speed"] = 0}
    },
    function()
      Timer:after(
        DELAY_WRAP_UP_STATE,
        function()
          gStateMachine:change(
            "wrap-up",
            {
              ["tilesBonus"] = self.tilesBonus,
              ["tilesOffset"] = self.tilesOffset,
              ["car"] = self.car,
              ["cars"] = self.cars,
              ["timer"] = self.timer,
              ["collisions"] = self.collisions
            }
          )
        end
      )
    end
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
end

function StopState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  love.graphics.translate(VIRTUAL_WIDTH, 0)
  self.tilesBonus:render()
  self.tilesFinishLine:render()
  love.graphics.pop()

  for k, car in pairs(self.cars) do
    car:render()
  end
  self.car:render()
end
