TitleScreenState = Class({__includes = BaseState})

function TitleScreenState:init()
  self.title = {
    ["text"] = "Space\nInvaders",
    ["y"] = WINDOW_HEIGHT
  }

  self.hiScore = 1000
  self.record = {
    ["text"] = "Hi-Score:     " .. self.hiScore,
    ["alpha"] = 0
  }

  self.instruction = {
    ["text"] = "Push start",
    ["alpha"] = 0
  }

  self.isTweening = true
  Timer.tween(
    1.5,
    {
      [self.title] = {y = WINDOW_HEIGHT / 2 - 90}
    }
  ):finish(
    function()
      Timer.after(
        0.5,
        function()
          self.instruction.alpha = 1
          self.record.alpha = 1
          self.isTweening = false
          Timer.every(
            2,
            function()
              self.instruction.alpha = 0
              Timer.after(
                1,
                function()
                  self.instruction.alpha = 1
                end
              )
            end
          )
        end
      )
    end
  )
end

function TitleScreenState:update(dt)
  Timer.update(dt)

  if not self.isTweening then
    if love.keyboard.waspressed("escape") then
      love.event.quit()
    end

    if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
      gStateMachine:change("round")
    end
  end
end

function TitleScreenState:render()
  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(self.title.text:upper(), 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(36 / 255, 191 / 255, 97 / 255, self.record.alpha)
  love.graphics.printf(self.record.text:upper(), 0, 8, WINDOW_WIDTH, "center")

  love.graphics.setColor(252 / 255, 197 / 255, 34 / 255, self.instruction.alpha)
  love.graphics.printf(self.instruction.text:upper(), 0, WINDOW_HEIGHT / 2 + 64, WINDOW_WIDTH, "center")
end
