PlayState = BaseState:new()

local CAR_SPEED_Y = 70
local OFFSET_SPEED_CHANGE_SPEED = 50
local OFFSET_SPEED_MIN = 0.5
local OFFSET_SPEED_MAX = 2

function PlayState:enter(params)
  self.tiles = params.tiles
  self.car = params.car
  self.tilesOffset = params.tilesOffset

  local initialSpeed = params.tilesOffset.speed
  self.speed = {
    ["min"] = initialSpeed * OFFSET_SPEED_MIN,
    ["max"] = initialSpeed * OFFSET_SPEED_MAX
  }
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH then
    self.tilesOffset.value = self.tilesOffset.value % VIRTUAL_WIDTH
  end

  if love.keyboard.isDown("up") then
    self.car.y = math.max(0, self.car.y - CAR_SPEED_Y * dt)
  elseif love.keyboard.isDown("down") then
    self.car.y = math.min(VIRTUAL_HEIGHT - self.car.size, self.car.y + CAR_SPEED_Y * dt)
  end

  if love.keyboard.isDown("right") then
    self.tilesOffset.speed = math.min(self.speed.max, self.tilesOffset.speed + OFFSET_SPEED_CHANGE_SPEED * dt)
  elseif love.keyboard.isDown("left") then
    self.tilesOffset.speed = math.max(self.speed.min, self.tilesOffset.speed - OFFSET_SPEED_CHANGE_SPEED * dt)
  end

  self.car.animation:update(dt)
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  self.tiles:render()
  love.graphics.pop()

  self.car:render()
end
