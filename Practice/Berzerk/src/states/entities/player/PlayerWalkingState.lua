PlayerWalkingState = BaseState:new()

local PLAYER_ANIMATION_INTERVAL = 0.12
local PLAYER_UPDATE_SPEED = {
  ["x"] = 20,
  ["y"] = 10
}
local PLAYER_PROJECTILES = 1

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
  for k, wall in pairs(self.player.level.walls) do
    if self.player:collides(wall, 1) then
      isColliding = true
      break
    end
  end

  if not isColliding then
    for k, enemy in pairs(self.player.level.enemies) do
      if self.player:collides(enemy, 1) then
        isColliding = true
        enemy:changeState("idle")
        break
      end
    end
  end

  if isColliding then
    self.player:changeState("lose")
  end

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

  self.player.x = self.player.x + self.player.dx * dt
  self.player.y = self.player.y + self.player.dy * dt

  if
    self.player.x < self.player.level.room.x or
      self.player.x + self.player.width > self.player.level.room.x + self.player.level.room.width or
      self.player.y < self.player.level.room.y or
      self.player.y + self.player.height > self.player.level.room.y + self.player.level.room.height
   then
    gStateStack:push(
      TransitionState:new(
        {
          ["callback"] = function()
            gStateStack:pop()
            gStateStack:push(PlayState:new())
          end
        }
      )
    )
  end

  if not (directions["left"] or directions["right"] or directions["up"] or directions["down"]) then
    self.player:changeState("idle")
  end

  if love.keyboard.waspressed("return") and #self.player.projectiles < PLAYER_PROJECTILES then
    self.player:changeState("shoot")
  end
end
