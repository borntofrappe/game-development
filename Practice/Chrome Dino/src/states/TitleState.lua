TitleState = BaseState:new()

function TitleState:enter()
  self.ground = {
    ["x"] = 0,
    ["y"] = VIRTUAL_HEIGHT - gTextures.ground:getHeight()
  }

  self.dino = {
    ["x"] = 4,
    ["y"] = VIRTUAL_HEIGHT - 18
  }

  self.score = {
    ["hi"] = 1234,
    ["current"] = 0
  }
end

function TitleState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end

function TitleState:render()
  love.graphics.setColor(0.32, 0.32, 0.32)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(FormatScore(self.score), 0, 2, VIRTUAL_WIDTH, "right")

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures.ground, self.ground.x, self.ground.y)

  love.graphics.draw(gTextures.spritesheet, gQuads.dino["idle"][1], self.dino.x, self.dino.y)

  love.graphics.rectangle("fill", 32, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
