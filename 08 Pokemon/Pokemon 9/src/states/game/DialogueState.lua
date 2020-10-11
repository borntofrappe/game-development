DialogueState = Class({__includes = BaseState})

function DialogueState:init(...)
  self.textBox =
    TextBox(
    {
      ["text"] = {...},
      ["x"] = 4,
      ["y"] = 4,
      ["padding"] = 4,
      ["width"] = VIRTUAL_WIDTH - 8,
      ["height"] = self.height,
      ["callback"] = function()
        gStateStack:pop()
      end
    }
  )
end

function DialogueState:update(dt)
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self.textBox:next()
  end
end

function DialogueState:render()
  self.textBox:render()
end
