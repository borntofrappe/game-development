DialogueState = Class({__includes = BaseState})

function DialogueState:init(text)
  self.textBox =
    TextBox(
    {
      text = text,
      x = 4,
      y = 4,
      padding = 4,
      width = VIRTUAL_WIDTH - 8,
      height = self.height
    }
  )
end

function DialogueState:update(dt)
  if love.keyboard.wasPressed("escape") or love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateStack:pop()
  end
end

function DialogueState:render()
  self.textBox:render()
end
