PlayState = BaseState:new()

local CAR_SPEED_Y = 70
local OFFSET_UPDATE_SPEED = 50
local OFFSET_SLOWDOWN_SPEED = 200
local OFFSET_SPEED_MIN = 0.5
local OFFSET_SPEED_MAX = 2
local CAR_SPAWN_ODDS = 3

function PlayState:enter(params)
  self.y = {
    ["min"] = TILE_SIZE.texture,
    ["max"] = VIRTUAL_HEIGHT - TILE_SIZE.texture - TILE_SIZE.car
  }

  self.tiles = params.tiles
  self.car = params.car
  self.tilesOffset = params.tilesOffset

  self.initialSpeed = params.tilesOffset.speed
  self.speed = {
    ["min"] = self.initialSpeed * OFFSET_SPEED_MIN,
    ["max"] = self.initialSpeed * OFFSET_SPEED_MAX
  }

  self.colors = {}
  for color = 1, #gQuads["cars"] do
    if color ~= self.car.color then
      table.insert(self.colors, color)
    end
  end

  self.cars = {}
  local x = VIRTUAL_WIDTH
  local y = love.math.random(self.y.min, self.y.max)
  local color = self.colors[love.math.random(#self.colors)]
  local car = Car:new(x, y, color)
  local speed = self.initialSpeed
  car.speed = speed
  table.insert(self.cars, car)
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH then
    self.tilesOffset.value = self.tilesOffset.value % VIRTUAL_WIDTH

    if love.math.random(CAR_SPAWN_ODDS) == 1 then
      local xStart = self.cars[#self.cars].x > 0 and self.cars[#self.cars].x or 0
      local x = xStart + VIRTUAL_WIDTH
      local y = love.math.random(self.y.min, self.y.max)
      local color = self.colors[love.math.random(#self.colors)]
      local car = Car:new(x, y, color)
      local speed = love.math.random() * (self.speed.max * 0.8 - self.speed.min) + self.speed.min
      car.speed = speed
      table.insert(self.cars, car)
    end
  end

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

  self.car.animation:update(dt)
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  self.tiles:render()
  love.graphics.pop()

  for k, car in pairs(self.cars) do
    car:render()
  end

  self.car:render()

  -- love.graphics.setColor(0, 0, 0)
  -- love.graphics.print(self.counter, 6, 6)
end
