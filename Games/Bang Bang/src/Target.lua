Target = {}
Target.__index = Target

function Target:create(x, y)
  this = {
    ["x"] = x - TARGET_WIDTH,
    ["y"] = y - TARGET_HEIGHT,
    ["width"] = TARGET_WIDTH,
    ["height"] = TARGET_HEIGHT,
    ["isDestroyed"] = false
  }

  setmetatable(this, self)

  return this
end

function Target:render()
  love.graphics.setColor(1, 1, 1, 1)
  if self.isDestroyed then
    love.graphics.draw(
      gTextures["gameover"],
      self.x + self.width / 2 - gTextures["gameover"]:getWidth() / 2,
      self.y + TARGET_HEIGHT - gTextures["gameover"]:getHeight()
    )
  else
    love.graphics.draw(gTextures["target"], self.x, self.y)
  end
end
