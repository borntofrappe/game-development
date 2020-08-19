TitleScreenState = Class({__includes = BaseState})

function TitleScreenState:init()
  self.title = {
    ["image"] = love.graphics.newImage("res/graphics/title.png"),
    ["y"] = WINDOW_HEIGHT
  }
  self.title.width = self.title.image:getWidth()
  self.title.height = self.title.image:getHeight()
  self.title.x = WINDOW_WIDTH / 2 - self.title.width / 2

  self.instruction = {
    ["text"] = "Push start",
    ["alpha"] = 0
  }

  Timer.tween(
    1.5,
    {
      [self.title] = {y = WINDOW_HEIGHT / 2 - self.title.height / 1.5}
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
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.title.image, self.title.x, self.title.y)

  love.graphics.setFont(gFonts["normal"])
  -- love.graphics.setColor(74 / 137, 163 / 192, 151 / 255, 1)

  love.graphics.setColor(197 / 255, 163 / 255, 151 / 255, self.instruction.alpha)
  love.graphics.printf(self.instruction.text:upper(), 0, self.title.y + self.title.height, WINDOW_WIDTH, "center")
end
