StartState = Class({__includes = BaseState})

function StartState:init()
  self.button = {
    ["alpha"] = 0.15,
    ["min"] = 0.15,
    ["max"] = 0.5
  }

  self.animationDuration = 1.4

  Timer.tween(
    self.animationDuration / 2,
    {
      [self.button] = {alpha = self.button.max}
    }
  ):finish(
    function()
      Timer.tween(
        self.animationDuration / 2,
        {
          [self.button] = {alpha = self.button.min}
        }
      )
    end
  )

  self.interval =
    Timer.every(
    self.animationDuration * 1.25,
    function()
      Timer.tween(
        self.animationDuration / 2,
        {
          [self.button] = {alpha = self.button.max}
        }
      ):finish(
        function()
          Timer.tween(
            self.animationDuration / 2,
            {
              [self.button] = {alpha = self.button.min}
            }
          )
        end
      )
    end
  )

  self.overlay = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 1
  }
  self.transitionDuration = 0.5
  self.isTransitioning = true

  Timer.tween(
    self.transitionDuration,
    {
      [self.overlay] = {a = 0}
    }
  ):finish(
    function()
      self.isTransitioning = false
    end
  )
end

function StartState:update(dt)
  Timer.update(dt)
  if love.keyboard.wasPressed("escape") and not self.isTransitioning then
    love.event.quit()
  end

  if (love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return")) and not self.isTransitioning then
    self.isTransitioning = true
    Timer.tween(
      self.transitionDuration,
      {
        [self.overlay] = {a = 1}
      }
    ):finish(
      function()
        self.interval:remove()
        gStateMachine:change("select")
      end
    )
  end
end

function StartState:render()
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Picross", 0, WINDOW_HEIGHT / 2 - gSizes["height-font-big"], WINDOW_WIDTH, "center")

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle(
    "line",
    WINDOW_WIDTH / 2 - 68 + 2,
    WINDOW_HEIGHT * 3 / 4 - gSizes["height-font-normal"] / 2 - 8 + 2,
    136,
    gSizes["height-font-normal"] + 16
  )

  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle(
    "line",
    WINDOW_WIDTH / 2 - 68,
    WINDOW_HEIGHT * 3 / 4 - gSizes["height-font-normal"] / 2 - 8,
    136,
    gSizes["height-font-normal"] + 16
  )

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, self.button.alpha)

  love.graphics.rectangle(
    "fill",
    WINDOW_WIDTH / 2 - 68,
    WINDOW_HEIGHT * 3 / 4 - gSizes["height-font-normal"] / 2 - 8,
    136,
    gSizes["height-font-normal"] + 16
  )

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.printf(
    "Levels",
    2,
    WINDOW_HEIGHT * 3 / 4 - gSizes["height-font-normal"] / 2 + 2,
    WINDOW_WIDTH,
    "center"
  )

  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.printf("Levels", 0, WINDOW_HEIGHT * 3 / 4 - gSizes["height-font-normal"] / 2, WINDOW_WIDTH, "center")

  love.graphics.setColor(self.overlay.r, self.overlay.g, self.overlay.b, self.overlay.a)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
end
