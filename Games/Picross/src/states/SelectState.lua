SelectState = Class({__includes = BaseState})

function SelectState:enter(params)
  self.levels = {}
  self.completedLevels = params and params.completedLevels or {}

  for i = 1, #LEVELS do
    local number = self.completedLevels[i] and i or 0
    self.levels[i] =
      Level(
      {
        ["number"] = number,
        ["hideHints"] = true,
        ["size"] = 36
      }
    )
  end

  self.padding = 92
  self.spacing = (WINDOW_WIDTH - self.padding * 2) / (#self.levels - 1)

  self.button = {
    ["alpha"] = 0.15,
    ["min"] = 0.15,
    ["max"] = 0.45,
    ["selection"] = params and params.selection or 1
  }

  self.animationDuration = 1

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
end

function SelectState:update(dt)
  Timer.update(dt)

  if love.keyboard.wasPressed("escape") then
    self.interval:remove()
    gStateMachine:change("start")
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self.interval:remove()
    gStateMachine:change(
      "play",
      {
        ["selection"] = self.button.selection,
        ["completedLevels"] = self.completedLevels
      }
    )
  end

  if love.keyboard.wasPressed("right") then
    self.button.selection = self.button.selection == #self.levels and 1 or self.button.selection + 1
  elseif love.keyboard.wasPressed("left") then
    self.button.selection = self.button.selection == 1 and #self.levels or self.button.selection - 1
  end
end

function SelectState:render()
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setFont(gFonts["normal"])
  if self.completedLevels[self.button.selection] then
    love.graphics.printf(self.levels[self.button.selection].name, 0, WINDOW_HEIGHT * 3 / 4, WINDOW_WIDTH, "center")
  else
    love.graphics.printf("Level " .. self.button.selection, 0, WINDOW_HEIGHT * 3 / 4, WINDOW_WIDTH, "center")
  end

  love.graphics.translate(self.padding - self.spacing, WINDOW_HEIGHT / 2)

  love.graphics.setLineWidth(2)
  for i, level in ipairs(self.levels) do
    love.graphics.translate(self.spacing, 0)

    if i == self.button.selection then
      love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, self.button.alpha)
    else
      love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
    end
    love.graphics.rectangle("fill", -28, -28, 56, 56)
    love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
    love.graphics.rectangle("line", -26, -26, 56, 56)
    love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
    love.graphics.rectangle("line", -28, -28, 56, 56)

    level:render()
  end
end
