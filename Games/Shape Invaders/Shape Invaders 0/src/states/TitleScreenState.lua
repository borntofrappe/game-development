TitleScreenState = Class({__includes = BaseState})

function TitleScreenState:init()
  self.title = {
    ["text"] = TITLE,
    ["y"] = WINDOW_HEIGHT
  }

  self.instruction = {
    ["text"] = "Push start",
    ["alpha"] = 0
  }

  Timer.tween(
    1.5,
    {
      [self.title] = {y = WINDOW_HEIGHT / 2 - 100}
    }
  ):finish(
    function()
      Timer.after(
        0.5,
        function()
          self.instruction.alpha = 1
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
end

function TitleScreenState:render()
  love.graphics.setColor(0.15, 0.9, 0.35, 1)
  love.graphics.setFont(gFonts["title"])
  love.graphics.printf(self.title.text:upper(), 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setColor(0.85, 0.52, 0.5, self.instruction.alpha)
  love.graphics.setFont(gFonts["text"])
  love.graphics.printf(self.instruction.text:upper(), 0, WINDOW_HEIGHT / 2 + 48, WINDOW_WIDTH, "center")
end
