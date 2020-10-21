StartState = Class({__includes = BaseState})

function StartState:init()
  -- fade-in
  self.overlay = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 1
  }
  self.transitionDuration = TRANSITION_DURATION / 2
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

  -- button specs
  self.button = {
    ["x"] = WINDOW_WIDTH / 2 - 68,
    ["y"] = WINDOW_HEIGHT * 3 / 4 - gSizes["height-font-normal"] / 2 - 8,
    ["width"] = 136,
    ["height"] = gSizes["height-font-normal"] + 16,
    ["alpha"] = 0.15,
    ["min"] = 0.15,
    ["max"] = 0.45
  }

  -- opacity animation
  self.animationDuration = ANIMATION_DURATION
  -- immediate
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
  -- at an interval
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
end

function StartState:update(dt)
  Timer.update(dt)

  -- keyboard input
  if love.keyboard.wasPressed("escape") and not self.isTransitioning then
    love.event.quit()
  end

  if (love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return")) and not self.isTransitioning then
    self:goToSelectState()
  end

  -- mouse input
  if love.mouse.wasPressed(1) and not self.isTransitioning then
    local x, y = love.mouse:getPosition()
    if
      x > self.button.x and x < self.button.x + self.button.width and y > self.button.y and
        y < self.button.y + self.button.height
     then
      self:goToSelectState()
    end
  end
end

function StartState:render()
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Picross", 0, WINDOW_HEIGHT / 2 - gSizes["height-font-big"], WINDOW_WIDTH, "center")

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", self.button.x + 2, self.button.y + 2, self.button.width, self.button.height)

  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", self.button.x, self.button.y, self.button.width, self.button.height)

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, self.button.alpha)

  love.graphics.rectangle("fill", self.button.x, self.button.y, self.button.width, self.button.height)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.printf("Levels", 2, self.button.y + 10, WINDOW_WIDTH, "center")

  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.printf("Levels", 0, self.button.y + 8, WINDOW_WIDTH, "center")

  love.graphics.setColor(self.overlay.r, self.overlay.g, self.overlay.b, self.overlay.a)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
end

function StartState:goToSelectState()
  self.isTransitioning = true

  -- fade-out
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
