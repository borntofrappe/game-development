VictoryState = Class({__includes = BaseState})

function VictoryState:init()
  self.overlay = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 0
  }
  self.transitionDuration = 0.5
end

function VictoryState:enter(params)
  self.completedLevels = params.completedLevels
  self.selection = params.selection
  self.completedLevels[self.selection] = true

  self.level = params.level
  self.size = self.level.size

  self.level.hideHints = true

  self.timer = params.timer

  self.message = {
    ["text"] = self.level.name,
    ["a"] = 0
  }

  self.background = {
    ["r"] = gColors["highlight"].r,
    ["g"] = gColors["highlight"].g,
    ["b"] = gColors["highlight"].b,
    ["a"] = 1
  }

  Timer.tween(
    0.75,
    {
      [self.background] = {a = 0},
      [self.message] = {a = 1}
    }
  ):finish(
    function()
      Timer.after(
        2.5,
        function()
          Timer.tween(
            self.transitionDuration,
            {
              [self.overlay] = {a = 1}
            }
          ):finish(
            function()
              gStateMachine:change(
                "select",
                {
                  ["selection"] = self.selection,
                  ["completedLevels"] = self.completedLevels
                }
              )
            end
          )
        end
      )
    end
  )
end

function VictoryState:update(dt)
  Timer.update(dt)
end

function VictoryState:render()
  love.graphics.translate(WINDOW_WIDTH * 5 / 7, WINDOW_HEIGHT * 9 / 14)
  love.graphics.setColor(self.background.r, self.background.g, self.background.b, self.background.a)
  love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)

  self.level:render()

  love.graphics.translate(-WINDOW_WIDTH * 5 / 7, -WINDOW_HEIGHT * 9 / 14)

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.print(
    "Level " .. self.selection,
    WINDOW_WIDTH / 4 - 90,
    WINDOW_HEIGHT / 4 - 7 - 8 - gSizes["height-font-small"]
  )

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 4 - 86, WINDOW_HEIGHT / 4 - 3, 140, 12 + gSizes["height-font-normal"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 4 - 90, WINDOW_HEIGHT / 4 - 7, 140, 12 + gSizes["height-font-normal"])
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.printf(formatTimer(self.timer), WINDOW_WIDTH / 4 - 84, WINDOW_HEIGHT / 4, 128, "right")

  love.graphics.setFont(gFonts["medium"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, self.message.a)
  love.graphics.printf(
    self.message.text,
    0,
    WINDOW_HEIGHT * 9 / 14 + self.size / 2 - gSizes["height-font-medium"],
    WINDOW_WIDTH * 5 / 7 - self.size / 2,
    "center"
  )

  love.graphics.setColor(self.overlay.r, self.overlay.g, self.overlay.b, self.overlay.a)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
end
