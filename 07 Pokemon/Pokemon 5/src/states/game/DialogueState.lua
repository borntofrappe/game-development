DialogueState = Class({__includes = BaseState})

local PADDING = 4

function DialogueState:init(text)
  self.text = text

  local _, lines = self.text:gsub("\n", "")

  self.height = gFonts["small"]:getHeight() * (lines + 1) + PADDING * 2
end

function DialogueState:update(dt)
  if love.keyboard.wasPressed("escape") or love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateStack:pop()
  end
end

function DialogueState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", PADDING, PADDING, VIRTUAL_WIDTH - 8, self.height, 5)
  love.graphics.setColor(0.15, 0.2, 0.6)
  love.graphics.rectangle("fill", PADDING, PADDING, VIRTUAL_WIDTH - 8, self.height, 5)

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(self.text, 8, 8)
end
