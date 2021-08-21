FinishState = BaseState:new()

function FinishState:enter(params)
  self.tiles = params.tiles
  self.tilesOffset = params.tilesOffset
  self.car = params.car
  self.cars = params.cars
  self.yThreshold = params.yThreshold
  self.timer = params.timer

  self.tilesFinishLine =
    Tiles:new(
    2,
    ROWS,
    {
      ["inner"] = 4,
      ["outer"] = 2,
      ["outermost"] = 3
    }
  )

  self.tilesBonus = Tiles:new()
end

function FinishState:update(dt)
  self.timer = self.timer + dt

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH then
    gStateMachine:change(
      "stop",
      {
        ["tilesFinishLine"] = self.tilesFinishLine,
        ["tilesBonus"] = self.tilesBonus,
        ["tilesOffset"] = self.tilesOffset,
        ["car"] = self.car,
        ["cars"] = self.cars,
        ["timer"] = self.timer
      }
    )
  end

  if love.keyboard.isDown("up") then
    self.car.y = math.max(0, self.car.y - Y_SPEED * dt)
  elseif love.keyboard.isDown("down") then
    self.car.y = math.min(VIRTUAL_HEIGHT - self.car.size, self.car.y + Y_SPEED * dt)
  end

  if self.car.y < self.yThreshold.min or self.car.y > self.yThreshold.max then
    self.tilesOffset.speed = math.max(OFFSET_SPEED_CAR.min, self.tilesOffset.speed - SLOWDOWN_SPEED * dt)
  end

  if love.keyboard.isDown("right") then
    self.tilesOffset.speed = math.min(OFFSET_SPEED_CAR.max, self.tilesOffset.speed + X_SPEED * dt)
  elseif love.keyboard.isDown("left") then
    self.tilesOffset.speed = math.max(OFFSET_SPEED_CAR.min, self.tilesOffset.speed - X_SPEED * dt)
  end

  for k, car in pairs(self.cars) do
    car:update(dt)
    car.x = car.x + (car.speed - self.tilesOffset.speed) * dt

    if car:collides(self.car) then
      if car.x > self.car.x then
        self.tilesOffset.speed = OFFSET_SPEED_CAR.min
      else
        car.speed = OFFSET_SPEED_CARS.min
      end
    end

    for j, c in pairs(self.cars) do
      if j ~= k and car:collides(c) then
        if car.x > c.x then
          c.speed = OFFSET_SPEED_CARS.min
        else
          car.speed = OFFSET_SPEED_CARS.min
        end
      end
    end
  end

  self.car:update(dt)
end

function FinishState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  self.tiles:render()

  love.graphics.translate(VIRTUAL_WIDTH, 0)
  self.tilesBonus:render()
  self.tilesFinishLine:render()
  love.graphics.pop()

  for k, car in pairs(self.cars) do
    car:render()
  end
  self.car:render()
end
