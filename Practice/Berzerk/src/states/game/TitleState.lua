TitleState = BaseState:new()

function TitleState:enter()
  local yEnd = VIRTUAL_HEIGHT / 2
  self.enemy = Enemy:new(VIRTUAL_WIDTH / 2 - SPRITE_SIZE / 2, VIRTUAL_HEIGHT, "walking-up")

  self.title = {
    ["text"] = "Berzerk",
    ["y"] = yEnd - 8 - gFonts.large:getHeight()
  }

  self.message = nil

  Timer:tween(
    4,
    {
      [self.enemy] = {["y"] = VIRTUAL_HEIGHT / 2}
    },
    function()
      self.enemy:changeState("idle")
      Timer:after(
        1,
        function()
          self.message = Message:new(yEnd + self.enemy.size + 8, "Intruder alert!")
        end
      )
    end
  )
end

function TitleState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("up") then
    self.enemy:changeState("walking-up")
  end

  if love.keyboard.waspressed("right") then
    self.enemy:changeState("walking-right")
  end

  if love.keyboard.waspressed("down") then
    self.enemy:changeState("walking-down")
  end

  if love.keyboard.waspressed("left") then
    self.enemy:changeState("walking-left")
  end

  self.enemy:update(dt)
end

function TitleState:render()
  love.graphics.setColor(0.824, 0.824, 0.824)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")

  self.enemy:render()
  if self.message then
    self.message:render()
  end
end
