SelectState = Class({__includes = BaseState})

function SelectState:init()
  -- fade-in
  self.overlay = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 1
  }
  self.transitionDuration = TRANSITION_DURATION / 2
  self.isTransitioning = true

  self.mouseInputButton = {
    ["x"] = 0,
    ["y"] = 0,
    ["r"] = 32
  }

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

function SelectState:enter(params)
  self.levels = {}
  self.completedLevels = params and params.completedLevels or {}

  for i = 1, #LEVELS do
    -- default to 0 for the grid describing the question mark
    local number = self.completedLevels[i] and i or 0
    self.levels[i] =
      Level(
      {
        ["number"] = number,
        ["hideHints"] = true,
        ["gridSize"] = 36
      }
    )
  end

  self.padding = 92
  self.spacing = (WINDOW_WIDTH - self.padding * 2) / (#self.levels - 1)

  self.button = {
    ["y"] = WINDOW_HEIGHT / 2 - 28,
    ["width"] = 56,
    ["height"] = 56,
    ["alpha"] = 0.15,
    ["min"] = 0.15,
    ["max"] = 0.45,
    ["selection"] = params and params.selection or 1
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

function SelectState:update(dt)
  Timer.update(dt)

  -- keyboard input
  if love.keyboard.wasPressed("escape") and not self.isTransitioning then
    self:goToStartState()
  end

  if (love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return")) and not self.isTransitioning then
    self:goToPlayState()
  end

  if love.keyboard.wasPressed("right") then
    self.button.selection = self.button.selection == #self.levels and 1 or self.button.selection + 1
  elseif love.keyboard.wasPressed("left") then
    self.button.selection = self.button.selection == 1 and #self.levels or self.button.selection - 1
  end

  -- mouse input
  local x, y = love.mouse:getPosition()
  -- update selection on mouseover
  if y > self.button.y and y < self.button.y + self.button.height then
    for i = 1, #self.levels do
      if
        x > self.padding - self.button.width / 2 + (i - 1) * (self.spacing) and
          x < self.padding - self.button.width / 2 + (i - 1) * (self.spacing) + self.button.width
       then
        self.button.selection = i
        break
      end
    end
  end

  -- update the state on mouseclick
  if love.mouse.wasPressed(1) and not self.isTransitioning then
    local x, y = love.mouse:getPosition()
    -- move to the selected level if overlapping one of the buttons
    if y > self.button.y and y < self.button.y + self.button.height then
      for i = 1, #self.levels do
        if
          x > self.padding - self.button.width / 2 + (i - 1) * (self.spacing) and
            x < self.padding - self.button.width / 2 + (i - 1) * (self.spacing) + self.button.width
         then
          self:goToPlayState()
          break
        end
      end
    end
    -- move to the start screen if overlapping the back button
    if ((x - self.mouseInputButton.x) ^ 2 + (y - self.mouseInputButton.y) ^ 2) ^ 0.5 < self.mouseInputButton.r then
      self:goToStartState()
    end
  end
end

function SelectState:render()
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setFont(gFonts["normal"])
  -- show the name of the level if completed
  if self.completedLevels[self.button.selection] then
    love.graphics.printf(
      self.levels[self.button.selection].name,
      0,
      WINDOW_HEIGHT * 3 / 4 - gSizes["height-font-normal"] / 2,
      WINDOW_WIDTH,
      "center"
    )
  else
    love.graphics.printf(
      "Level " .. self.button.selection,
      0,
      WINDOW_HEIGHT * 3 / 4 - gSizes["height-font-normal"] / 2,
      WINDOW_WIDTH,
      "center"
    )
  end

  love.graphics.translate(self.padding - self.spacing, self.button.y + self.button.height / 2)
  love.graphics.setLineWidth(2)
  for i, level in ipairs(self.levels) do
    love.graphics.translate(self.spacing, 0)

    -- animate the background of the selection
    if i == self.button.selection then
      love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, self.button.alpha)
    else
      love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
    end
    love.graphics.rectangle(
      "fill",
      -self.button.width / 2,
      -self.button.height / 2,
      self.button.width,
      self.button.height
    )
    love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
    love.graphics.rectangle(
      "line",
      -self.button.width / 2,
      -self.button.height / 2,
      self.button.width,
      self.button.height
    )
    love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
    love.graphics.rectangle(
      "line",
      -self.button.width / 2,
      -self.button.height / 2,
      self.button.width,
      self.button.height
    )

    level:render()
  end

  love.graphics.translate(-self.padding - self.spacing * (#self.levels - 1), -WINDOW_HEIGHT / 2)

  if gMouseInput then
    love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", self.mouseInputButton.x, self.mouseInputButton.y, self.mouseInputButton.r)
    love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
    love.graphics.circle("fill", self.mouseInputButton.x, self.mouseInputButton.y, self.mouseInputButton.r)
    love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
    love.graphics.setLineWidth(3)
    love.graphics.line(
      self.mouseInputButton.x + 5,
      self.mouseInputButton.y + 7,
      self.mouseInputButton.x + 15,
      self.mouseInputButton.y + 17
    )
    love.graphics.line(
      self.mouseInputButton.x + 15,
      self.mouseInputButton.y + 7,
      self.mouseInputButton.x + 5,
      self.mouseInputButton.y + 17
    )
  end

  love.graphics.setColor(self.overlay.r, self.overlay.g, self.overlay.b, self.overlay.a)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
end

function SelectState:goToStartState()
  self.isTransitioning = true

  Timer.tween(
    self.transitionDuration,
    {
      [self.overlay] = {a = 1}
    }
  ):finish(
    function()
      self.interval:remove()
      gStateMachine:change("start")
    end
  )
end

function SelectState:goToPlayState()
  self.isTransitioning = true

  Timer.tween(
    self.transitionDuration,
    {
      [self.overlay] = {a = 1}
    }
  ):finish(
    function()
      self.interval:remove()
      gStateMachine:change(
        "play",
        {
          ["selection"] = self.button.selection,
          ["completedLevels"] = self.completedLevels
        }
      )
    end
  )
end
