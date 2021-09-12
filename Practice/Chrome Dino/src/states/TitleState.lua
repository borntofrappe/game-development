TitleState = BaseState:new()

function TitleState:enter()
  self.ground = {
    ["x"] = 0,
    ["y"] = VIRTUAL_HEIGHT - gTextures.ground:getHeight()
  }

  self.dino = {
    ["x"] = 4,
    ["y"] = self.ground.y - 14,
    ["state"] = "idle",
    ["animation"] = Animation:new({1}, 1)
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

  if self.dino.animation then
    self.dino.animation:update(dt)
  end

  if love.keyboard.waspressed("space") then
    self.dino.state = "run"
    self.dino.y = self.ground.y - 14
    self.dino.animation = Animation:new({1, 2}, 0.12)
  end

  if love.keyboard.waspressed("down") then
    self.dino.state = "duck"
    self.dino.y = self.ground.y - 9
    self.dino.animation = Animation:new({1, 2}, 0.12)
  end

  if love.keyboard.waspressed("g") then
    self.dino.state = "gameover"
    self.dino.y = self.ground.y - 14
    self.dino.animation = Animation:new({1}, 0.12)
  end
end

function TitleState:render()
  love.graphics.setColor(0.32, 0.32, 0.32)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(FormatScore(self.score), 0, 2, VIRTUAL_WIDTH, "right")

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures.ground, self.ground.x, self.ground.y)

  love.graphics.draw(
    gTextures.spritesheet,
    gQuads.dino[self.dino.state][self.dino.animation:getCurrentFrame()],
    self.dino.x,
    self.dino.y
  )

  love.graphics.rectangle("fill", 32, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
