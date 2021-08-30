DialogueState = BaseState:new()

function DialogueState:new(chunks)
  local textBoxes = {}
  for i, chunk in ipairs(chunks) do
    table.insert(textBoxes, TextBox:new(chunk))
  end

  local this = {
    ["textBoxes"] = textBoxes,
    ["index"] = 1
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function DialogueState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateStack:pop()
  end

  if love.keyboard.waspressed("return") then
    if self.index == #self.textBoxes then
      gStateStack:pop()
    else
      self.index = self.index + 1
    end
  end
end

function DialogueState:render()
  self.textBoxes[self.index]:render()
end
