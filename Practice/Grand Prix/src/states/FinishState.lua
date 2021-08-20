FinishState = BaseState:new()

function FinishState:enter(params)
  self.tiles = params.tiles

  self.finishTiles = {}

  local tileSize = TILE_SIZE.texture

  for column = 1, 2 do
    for row = 1, ROWS do
      local x = (column - 1) * tileSize
      local y = (row - 1) * tileSize
      local id = 3

      if row == 1 or row == ROWS then
        id = 1
      elseif row == 2 or row == ROWS - 1 then
        id = 4
      end

      local tile = Tile:new(x, y, id)
      table.insert(self.finishTiles, tile)
    end
  end

  self.nextTiles = Tiles:new()
  self.tilesOffset = params.tilesOffset
  self.car = params.car
  self.cars = params.cars
  self.y = params.y
  self.speed = params.speed

  self.hasFinished = false
end

function FinishState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()
    gStateMachine:change("start")
  end

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH and not self.hasFinished then
    self.hasFinished = true
    Timer:tween(
      2,
      {
        [self.tilesOffset] = {["speed"] = 0}
      }
    )

    for k, car in pairs(self.cars) do
      car.speed = 0
      car.x = car.x + (car.speed - self.tilesOffset.speed) * dt
    end
  end

  if not self.hasFinished then
    if love.keyboard.isDown("up") then
      self.car.y = math.max(0, self.car.y - CAR_SPEED_Y * dt)
    elseif love.keyboard.isDown("down") then
      self.car.y = math.min(VIRTUAL_HEIGHT - self.car.size, self.car.y + CAR_SPEED_Y * dt)
    end

    if self.car.y < self.y.min or self.car.y > self.y.max then
      self.tilesOffset.speed = math.max(self.speed.min, self.tilesOffset.speed - OFFSET_SLOWDOWN_SPEED * dt)
    end

    if love.keyboard.isDown("right") then
      self.tilesOffset.speed = math.min(self.speed.max, self.tilesOffset.speed + OFFSET_UPDATE_SPEED * dt)
    elseif love.keyboard.isDown("left") then
      self.tilesOffset.speed = math.max(self.speed.min, self.tilesOffset.speed - OFFSET_UPDATE_SPEED * dt)
    end

    for k, car in pairs(self.cars) do
      car:update(dt)
      car.x = car.x + (car.speed - self.tilesOffset.speed) * dt

      if car:collides(self.car) then
        if car.x > self.car.x then
          self.tilesOffset.speed = self.speed.min
        else
          car.speed = self.speed.min
        end
      end

      for j, c in pairs(self.cars) do
        if j ~= k and car:collides(c) then
          if car.x > c.x then
            c.speed = self.speed.min
          else
            car.speed = self.speed.min
          end
        end
      end
    end
    self.car:update(dt)
  end
end

function FinishState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  self.tiles:render()

  love.graphics.translate(VIRTUAL_WIDTH, 0)

  self.nextTiles:render()
  for k, tile in pairs(self.finishTiles) do
    tile:render()
  end
  love.graphics.pop()

  for k, car in pairs(self.cars) do
    car:render()
  end
  self.car:render()
end
