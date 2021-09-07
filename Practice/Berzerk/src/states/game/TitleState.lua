TitleState = BaseState:new()

function TitleState:enter()
  self.title = {
    ["text"] = "Berzerk",
    ["y"] = VIRTUAL_HEIGHT / 2 - gFonts.large:getHeight() - 2
  }
  self.player = Player:new(VIRTUAL_WIDTH / 2 - SPRITE_SIZE / 2, self.title.y + gFonts.large:getHeight() + 2)
  self.enemy = Enemy:new()
end

function TitleState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  self.player:update(dt)
  self.enemy:update(dt)
end

function TitleState:render()
  love.graphics.setColor(0.824, 0.824, 0.824)

  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")

  self.player:render()
  self.enemy:render()
end
