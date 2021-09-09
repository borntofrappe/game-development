PlayerWalkingState = BaseState:new()

local PLAYER_ANIMATION_INTERVAL = 0.15
local PLAYER_UPDATE_SPEED = {
  ["x"] = 15,
  ["y"] = 10
}

function PlayerWalkingState:new(player)
  player.currentAnimation = Animation:new({2, 3}, PLAYER_ANIMATION_INTERVAL)

  local this = {
    ["player"] = player
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerWalkingState:update(dt)
  self.player.currentAnimation:update(dt)

  local isColliding = false
  for k, wall in pairs(self.player.walls) do
    if self.player:collides(wall) then
      isColliding = true
      break
    end
  end

  if isColliding then
    self.player:changeState("lose")
  else
    local directions = {
      ["right"] = love.keyboard.isDown("right"),
      ["left"] = love.keyboard.isDown("left"),
      ["up"] = love.keyboard.isDown("up"),
      ["down"] = love.keyboard.isDown("down")
    }

    if directions["right"] then
      self.player.direction = "right"
      self.player.dx = PLAYER_UPDATE_SPEED.x
    elseif directions["left"] then
      self.player.direction = "left"
      self.player.dx = -PLAYER_UPDATE_SPEED.x
    else
      self.player.dx = 0
    end

    if directions["up"] then
      self.player.dy = -PLAYER_UPDATE_SPEED.y
    elseif directions["down"] then
      self.player.dy = PLAYER_UPDATE_SPEED.y
    else
      self.player.dy = 0
    end

    self.player.x = math.max(0, math.min(VIRTUAL_WIDTH - self.player.width, self.player.x + self.player.dx * dt))
    self.player.y = math.max(0, math.min(VIRTUAL_HEIGHT - self.player.height, self.player.y + self.player.dy * dt))

    if not (directions["left"] or directions["right"] or directions["up"] or directions["down"]) then
      self.player:changeState("idle")
    end

    if love.keyboard.waspressed("return") then
      self.player:changeState("shoot")
    end
  end
end
