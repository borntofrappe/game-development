DialogueState = Class({__includes = BaseState})

function DialogueState:init()
end

function DialogueState:update(dt)
  if love.keyboard.wasPressed("escape") or love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateStack:pop()
  end
end

function DialogueState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", 4, 4, VIRTUAL_WIDTH - 8, 64 - 8, 5)
  love.graphics.setColor(0.15, 0.2, 0.6)
  love.graphics.rectangle("fill", 4, 4, VIRTUAL_WIDTH - 8, 64 - 8, 5)

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(
    "Welcome to a wonderful world populated by\n" .. #POKEDEX .. " feisty creatures.\nCan you find them all?",
    8,
    8
  )
end
