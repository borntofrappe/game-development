DriveState = BaseState:new()

-- in a counter keep track of the number of times the tiles are reset horizontally
local FINISH_COUNTER = 20
-- do not spawn car in the last segment
local CARS_COUNTER = FINISH_COUNTER - 1
-- limit the number of cars ahead of the player
local CARS_AHEAD_THRESHOLD = 3

function DriveState:enter(params)
  -- limit the area in which cars spawn
  -- outside of the threshold slow down the player
  self.yThreshold = {
    ["min"] = TEXTURE_SIZE,
    ["max"] = VIRTUAL_HEIGHT - TEXTURE_SIZE - CAR_SIZE
  }

  self.tiles = params.tiles
  self.tilesOffset = params.tilesOffset
  self.car = params.car

  -- store the colors different from the one describing the player to avoid conflicting hues
  local colors = {}
  for color = 1, #gQuads["cars"] do
    if color ~= self.car.color then
      table.insert(colors, color)
    end
  end

  self.colors = colors

  self.cars = {}

  self.counter = 0

  -- keep track of the time and front collisions
  self.timer = 0
  self.collisions = 0
end

function DriveState:update(dt)
  self.timer = self.timer + dt

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH then
    self.counter = self.counter + 1
    self.tilesOffset.value = self.tilesOffset.value % VIRTUAL_WIDTH

    if self.counter < CARS_COUNTER then
      local carsAhead = 0
      for k, car in pairs(self.cars) do
        if car.x > VIRTUAL_WIDTH then
          carsAhead = carsAhead + 1
          if carsAhead >= CARS_AHEAD_THRESHOLD then
            break
          end
        end
      end

      if carsAhead < CARS_AHEAD_THRESHOLD then
        local x = self.car.x + VIRTUAL_WIDTH + love.math.random() * VIRTUAL_WIDTH
        local y = love.math.random(self.yThreshold.min, self.yThreshold.max)
        local color = self.colors[love.math.random(#self.colors)]
        local car = Car:new(x, y, color)
        local speed = love.math.random() * (OFFSET_SPEED_CARS.max - OFFSET_SPEED_CARS.min) + OFFSET_SPEED_CARS.min
        car.speed = speed
        table.insert(self.cars, car)
      end
    end

    if self.counter > FINISH_COUNTER then
      gStateMachine:change(
        "finish",
        {
          ["tiles"] = self.tiles,
          ["tilesOffset"] = self.tilesOffset,
          ["car"] = self.car,
          ["cars"] = self.cars,
          ["yThreshold"] = self.yThreshold,
          ["timer"] = self.timer,
          ["collisions"] = self.collisions
        }
      )
    end
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
        self.collisions = self.collisions + 1
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

function DriveState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  self.tiles:render()
  love.graphics.pop()

  for k, car in pairs(self.cars) do
    car:render()
  end
  self.car:render()
end
