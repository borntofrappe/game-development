Player = {}

local PLAYER_SPEED = 250
local PLAYER_PROJECTILES_CAP = 1

function Player:new()
  local this = {
    ["x"] = WINDOW_WIDTH / 2 - PLAYER_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT - PLAYER_HEIGHT - WINDOW_PADDING,
    ["width"] = PLAYER_WIDTH,
    ["height"] = PLAYER_HEIGHT,
    ["dx"] = 0,
    ["speed"] = PLAYER_SPEED,
    ["projectiles"] = {},
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:update(dt)
  self.x = math.min(WINDOW_WIDTH - self.width - WINDOW_PADDING, math.max(WINDOW_PADDING, self.x + self.dx * dt))

  for k, projectile in pairs(self.projectiles) do
    projectile:update(dt)

    if not projectile.inPlay then
      table.remove(self.projectiles, k)
    end
  end

  if love.keyboard.waspressed("up") or love.keyboard.waspressed("space") then
    if #self.projectiles < PLAYER_PROJECTILES_CAP then
      table.insert(self.projectiles, Projectile:new(self.x + self.width / 2, self.y))
    end
  end

  if love.keyboard.isDown("right") then
    self.dx = self.speed
  elseif love.keyboard.isDown("left") then
    self.dx = self.speed * -1
  else
    self.dx = 0
  end
end

function Player:render()
  love.graphics.setColor(1, 1, 1)
  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end

  if self.inPlay then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gTextures["spritesheet"], gFrames["player"], self.x, self.y)
  end
end
