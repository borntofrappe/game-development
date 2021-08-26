PlayState = BaseState:init()

local UPDATE_SPEED = 100

function PlayState:new()
  local playerSize = 20
  local player = {
    ["x"] = WINDOW_WIDTH / 2 - playerSize / 2,
    ["y"] = WINDOW_HEIGHT / 2 - playerSize / 2,
    ["size"] = playerSize
  }

  local this = {
    ["player"] = player
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateStack:push(DialogueState:new(self.player))
  end

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.isDown("up") then
    self.player.y = math.max(0, self.player.y - UPDATE_SPEED * dt)
  elseif love.keyboard.isDown("down") then
    self.player.y = math.min(WINDOW_HEIGHT - self.player.size, self.player.y + UPDATE_SPEED * dt)
  end

  if love.keyboard.isDown("right") then
    self.player.x = math.min(WINDOW_WIDTH - self.player.size, self.player.x + UPDATE_SPEED * dt)
  elseif love.keyboard.isDown("left") then
    self.player.x = math.max(0, self.player.x - UPDATE_SPEED * dt)
  end
end

function PlayState:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", self.player.x, self.player.y, self.player.size, self.player.size)
  love.graphics.print("PlayState", 2, WINDOW_HEIGHT - 16)
end
