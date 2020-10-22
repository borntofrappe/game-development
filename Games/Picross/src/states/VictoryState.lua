VictoryState = Class({__includes = BaseState})

function VictoryState:init()
  self.overlay = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 0
  }
  self.transitionDuration = TRANSITION_DURATION / 2
  self.delayDuration = DELAY_DURATION
end

function VictoryState:enter(params)
  self.selection = params.selection
  self.level = params.level
  self.completedLevels = params.completedLevels
  self.completedLevels[self.selection] = true
  self.timer = params.timer
  self.grid = params.grid

  self.level.hideHints = true

  self.message = {
    ["text"] = self.level.name,
    ["x"] = 12,
    ["y"] = self.grid.y + self.grid.size / 2 - gSizes["height-font-medium"] / 2,
    ["width"] = self.grid.x - 24,
    ["a"] = 0
  }

  self.background = {
    ["r"] = gColors["highlight"].r,
    ["g"] = gColors["highlight"].g,
    ["b"] = gColors["highlight"].b,
    ["a"] = 1
  }

  Timer.tween(
    self.transitionDuration * 0.75,
    {
      [self.background] = {a = 0},
      [self.message] = {a = 1}
    }
  ):finish(
    function()
      Timer.after(
        self.delayDuration,
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
  love.graphics.translate(self.grid.x + self.grid.size / 2, self.grid.y + self.grid.size / 2)
  love.graphics.setColor(self.background.r, self.background.g, self.background.b, self.background.a)
  love.graphics.rectangle("fill", -self.grid.size / 2, -self.grid.size / 2, self.grid.size, self.grid.size)

  self.level:render()

  love.graphics.translate(-self.grid.x - self.grid.size / 2, -self.grid.y - self.grid.size / 2)

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.print("Level " .. self.selection, self.timer.x - 6, self.timer.y - 8 - gSizes["height-font-small"])

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.rectangle("fill", self.timer.x - 2, self.timer.y - 3, self.timer.width + 12, self.timer.height + 12)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle("fill", self.timer.x - 6, self.timer.y - 7, self.timer.width + 12, self.timer.height + 12)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.printf(formatTimer(self.timer.value), self.timer.x, self.timer.y, self.timer.width, "right")

  love.graphics.setFont(gFonts["medium"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, self.message.a)
  love.graphics.printf(self.message.text, self.message.x, self.message.y, self.message.width, "center")

  love.graphics.setColor(self.overlay.r, self.overlay.g, self.overlay.b, self.overlay.a)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
end
