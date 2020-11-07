PauseState = Class {__includes = BaseState}

function PauseState:init(def)
  self.translateX = def and def.translateX or 0
end

function PauseState:update(dt)
  if love.keyboard.wasReleased("down") then
    gStateStack:pop()
  end
end

function PauseState:render()
  love.graphics.translate(-self.translateX, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][backgroundVariant], 0, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][backgroundVariant], VIRTUAL_WIDTH, 0)
  love.graphics.translate(self.translateX, 0)

  love.graphics.draw(gTextures["alien"], gQuads["alien"][3], 8, VIRTUAL_HEIGHT - ALIEN_HEIGHT)
end
