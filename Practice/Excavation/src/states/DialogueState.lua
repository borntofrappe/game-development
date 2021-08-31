DialogueState = BaseState:new()

function DialogueState:new(def)
  local textBoxes = {}
  for i, chunk in ipairs(def.chunks) do
    table.insert(textBoxes, TextBox:new(chunk))
  end

  local this = {
    ["textBoxes"] = textBoxes,
    ["index"] = 1,
    ["callback"] = function()
      gStateStack:pop()

      if def.callback then
        def.callback()
      end
    end
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function DialogueState:update(dt)
  if love.keyboard.waspressed("escape") then
    self.callback()
  end

  if love.keyboard.waspressed("return") or love.mouse.waspressed(1) then
    if self.index == #self.textBoxes then
      self.callback()
    else
      self.index = self.index + 1
    end
  end
end

function DialogueState:render()
  self.textBoxes[self.index]:render()
end
