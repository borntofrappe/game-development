TitleState = BaseState:new()

function TitleState:enter()
  local yEnd = VIRTUAL_HEIGHT / 2
  self.enemy = Enemy:new(VIRTUAL_WIDTH / 2 - SPRITE_SIZE / 2, VIRTUAL_HEIGHT, "walking-up")

  self.title = {
    ["text"] = "Berzerk",
    ["y"] = yEnd - 8 - gFonts.large:getHeight()
  }

  self.message = nil

  Timer:after(
    1,
    function()
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
              self.message = Message:new(self.enemy.y + self.enemy.size + 8, "Intruder alert!")
            end
          )
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

  if love.keyboard.waspressed("return") then
    Timer:reset()
    gStateStack:push(
      TransitionState:new(
        {
          ["callback"] = function()
            gStateStack:pop()
            gStateStack:push(PlayState:new())
          end
        }
      )
    )
  end

  -- update only the animation as the y coordinate is tweened separately
  self.enemy.currentAnimation:update(dt)
end

function TitleState:render()
  love.graphics.setColor(0.427, 0.459, 0.906)
  love.graphics.setLineWidth(4)
  love.graphics.line(
    VIRTUAL_WIDTH / 3,
    VIRTUAL_HEIGHT - ROOM_PADDING,
    ROOM_PADDING,
    VIRTUAL_HEIGHT - ROOM_PADDING,
    ROOM_PADDING,
    ROOM_PADDING,
    VIRTUAL_WIDTH - ROOM_PADDING,
    ROOM_PADDING,
    VIRTUAL_WIDTH - ROOM_PADDING,
    VIRTUAL_HEIGHT - ROOM_PADDING,
    VIRTUAL_WIDTH * 2 / 3,
    VIRTUAL_HEIGHT - ROOM_PADDING
  )

  love.graphics.setColor(0.824, 0.824, 0.824)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")

  self.enemy:render()
  if self.message then
    self.message:render()
  end
end
