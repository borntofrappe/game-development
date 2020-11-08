ScrollState = Class {__includes = BaseState}

function ScrollState:init()
  self.translateX = 0
  self.player = {
    ["animation"] = ANIMATION["walk"]
  }
end

function ScrollState:update(dt)
  self.player.animation:update(dt)

  self.translateX = self.translateX + SCROLL_SPEED * dt
  if self.translateX >= VIRTUAL_WIDTH then
    self.translateX = 0
  end

  if love.keyboard.wasPressed("down") or love.keyboard.wasPressed("s") then
    gStateStack:push(
      PauseState(
        {
          player = self.player
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
    gQuads["alien"][self.player.animation:getCurrentFrame()],
    8,
    VIRTUAL_HEIGHT - ALIEN_HEIGHT
  )
end
