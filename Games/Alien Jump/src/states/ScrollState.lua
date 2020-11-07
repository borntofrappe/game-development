ScrollState = Class {__includes = BaseState}

function ScrollState:init()
  self.translateX = 0

  self.animation =
    Animation(
    {
      frames = {4, 5},
      interval = 0.1
    }
  )
end

function ScrollState:update(dt)
  self.animation:update(dt)

  self.translateX = self.translateX + SCROLL_SPEED * dt
  if self.translateX >= VIRTUAL_WIDTH then
    self.translateX = 0
  end

  if love.keyboard.wasPressed("down") then
    gStateStack:push(
      PauseState(
        {
          translateX = self.translateX
        }
      )
    )
  end
end

function ScrollState:render()
  love.graphics.translate(-self.translateX, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][backgroundVariant], 0, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][backgroundVariant], VIRTUAL_WIDTH, 0)
  love.graphics.translate(self.translateX, 0)

  love.graphics.draw(
    gTextures["alien"],
    gQuads["alien"][self.animation:getCurrentFrame()],
    8,
    VIRTUAL_HEIGHT - ALIEN_HEIGHT
  )
end
