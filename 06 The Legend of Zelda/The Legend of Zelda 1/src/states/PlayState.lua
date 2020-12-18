PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.room = Room()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end
  if love.keyboard.wasPressed("return") then
    gStateMachine:change("gameover")
  end
end

function PlayState:render()
  love.graphics.setColor(0.05, 0.027, 0.067)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.push()
  love.graphics.translate(0, MARGIN_TOP)
  self.room:render()
  love.graphics.pop()

  for i = 1, 4 do
    love.graphics.draw(gTextures["hearts"], gFrames["hearts"][5], PADDING + (i - 1) * (TILE_SIZE + 2), PADDING)
  end
end
