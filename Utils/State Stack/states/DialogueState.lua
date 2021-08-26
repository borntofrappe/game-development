DialogueState = BaseState:new()

local WHITESPACE = 6

function DialogueState:new(player)
  local message = {
    ["text"] = "Hello",
    ["x"] = player.x + player.size / 2 < WINDOW_WIDTH / 2 and player.x + player.size + 8 or player.x - 38,
    ["y"] = player.y + player.size / 2 < WINDOW_HEIGHT / 2 and player.y + player.size + WHITESPACE or
      player.y - 16 - WHITESPACE
  }

  local this = {
    ["message"] = message
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function DialogueState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") or love.keyboard.wasPressed("escape") then
    gStateStack:pop()
  end
end

function DialogueState:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("DialogueState", 2, WINDOW_HEIGHT - 16 - 16)

  love.graphics.rectangle("fill", self.message.x - 6, self.message.y - 3, 42, 16 + 6, 8)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(self.message.text, self.message.x, self.message.y)
end
