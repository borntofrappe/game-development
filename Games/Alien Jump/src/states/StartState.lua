StartState = Class {__includes = BaseState}

function StartState:update(dt)
  if love.keyboard.wasPressed("return") then
    gStateStack:pop()
    gStateStack:push(ScrollState())
  end
end

function StartState:render()
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][backgroundVariant], 0, 0)
  love.graphics.draw(gTextures["alien"], gQuads["alien"][1], 8, VIRTUAL_HEIGHT - ALIEN_HEIGHT)
end
