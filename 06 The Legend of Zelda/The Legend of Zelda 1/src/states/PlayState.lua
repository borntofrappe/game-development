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
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setColor(1, 1, 1, 1)
  self.room:render()

  for i = 1, 4 do
    love.graphics.draw(gTextures["hearts"], gFrames["hearts"][5], 6 + (i - 1) * (TILE_SIZE + 2), 6)
  end
end
