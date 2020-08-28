TitleScreenState = Class({__includes = BaseState})

function TitleScreenState:init()
  self.titleText = {
    ["text"] = "Space\nInvaders",
    ["y"] = WINDOW_HEIGHT
  }

  self.recordText = {
    ["text"] = "Hi-Score:     " .. gRecord,
    ["alpha"] = 0
  }

  self.instructionText = {
    ["text"] = "Push start",
    ["alpha"] = 0
  }

  self.isTweening = true
  self.tween =
    Timer.tween(
    1.5,
    {
      [self.titleText] = {y = WINDOW_HEIGHT / 2 - 88}
    }
  ):finish(
    function()
      Timer.after(
        0.5,
        function()
          self.instructionText.alpha = 1
          self.recordText.alpha = 1
          self.isTweening = false
          Timer.every(
            2,
            function()
              self.instructionText.alpha = 0
              Timer.after(
                1,
                function()
                  self.instructionText.alpha = 1
                end
              )
            end
          )

          Timer.after(
            10,
            function()
              self.tween:remove()
              gStateMachine:change("points")
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
      gSounds["menu"]:play()
      self.tween:remove()
      Timer.clear()
      gStateMachine:change("round", {})
    end
  end
end

function TitleScreenState:render()
  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(self.titleText.text:upper(), 0, self.titleText.y, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(36 / 255, 191 / 255, 97 / 255, self.recordText.alpha)
  love.graphics.printf(self.recordText.text:upper(), 0, 8, WINDOW_WIDTH, "center")

  love.graphics.setColor(252 / 255, 197 / 255, 34 / 255, self.instructionText.alpha)
  love.graphics.printf(self.instructionText.text:upper(), 0, WINDOW_HEIGHT * 2 / 3 - 24, WINDOW_WIDTH, "center")
end
