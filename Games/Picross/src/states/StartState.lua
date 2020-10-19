StartState = Class({__includes = BaseState})

function StartState:init()
  self.level =
    Level(
    {
      ["number"] = 0,
      ["hideHints"] = true
    }
  )
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
end

function StartState:update(dt)
  Timer.update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self.interval:remove()
    gStateMachine:change("select")
  end
end

function StartState:render()
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Picross", 0, WINDOW_HEIGHT / 2 - gFonts["big"]:getHeight(), WINDOW_WIDTH, "center")

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle(
    "line",
    WINDOW_WIDTH / 2 - 68 + 2,
    WINDOW_HEIGHT * 3 / 4 - gFonts["normal"]:getHeight() / 2 - 8 + 2,
    136,
    gFonts["normal"]:getHeight() + 16
  )

  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle(
    "line",
    WINDOW_WIDTH / 2 - 68,
    WINDOW_HEIGHT * 3 / 4 - gFonts["normal"]:getHeight() / 2 - 8,
    136,
    gFonts["normal"]:getHeight() + 16
  )

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, self.button.alpha)

  love.graphics.rectangle(
    "fill",
    WINDOW_WIDTH / 2 - 68,
    WINDOW_HEIGHT * 3 / 4 - gFonts["normal"]:getHeight() / 2 - 8,
    136,
    gFonts["normal"]:getHeight() + 16
  )

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.printf(
    "Levels",
    2,
    WINDOW_HEIGHT * 3 / 4 - gFonts["normal"]:getHeight() / 2 + 2,
    WINDOW_WIDTH,
    "center"
  )

  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.printf("Levels", 0, WINDOW_HEIGHT * 3 / 4 - gFonts["normal"]:getHeight() / 2, WINDOW_WIDTH, "center")
end
