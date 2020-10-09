DialogueState = Class({__includes = BaseState})

function DialogueState:init(text)
  self.text = text

  local lines = 1
  for n in string.gmatch(self.text, "\n") do
    lines = lines + 1
  end

  self.height = 16 * lines + 8
end

function DialogueState:update(dt)
  if love.keyboard.wasPressed("escape") or love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateStack:pop()
  end
end

function DialogueState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", 4, 4, VIRTUAL_WIDTH - 8, self.height, 5)
  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.rectangle("fill", 4, 4, VIRTUAL_WIDTH - 8, self.height, 5)

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(self.text, 8, 8)
end
