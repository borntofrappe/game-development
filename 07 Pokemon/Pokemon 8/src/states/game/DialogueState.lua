DialogueState = Class({__includes = BaseState})

function DialogueState:init(...)
  self.textBox =
    TextBox(
    {
      ["chunks"] = {...},
      ["x"] = 4,
      ["y"] = 4,
      ["padding"] = 4,
      ["width"] = VIRTUAL_WIDTH - 8,
      ["callback"] = function()
        gStateStack:pop()
      end
    }
  )
end

function DialogueState:update(dt)
  self.textBox:update(dt)
end

function DialogueState:render()
  self.textBox:render()
end
