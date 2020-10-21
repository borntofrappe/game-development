VictoryState = Class({__includes = BaseState})

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
    1,
    {
      [self.background] = {a = 0},
      [self.message] = {a = 1}
    }
  ):finish(
    function()
      Timer.after(
        3,
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

function VictoryState:update(dt)
  Timer.update(dt)
end

function VictoryState:render()
  love.graphics.translate(WINDOW_WIDTH * 5 / 7, WINDOW_HEIGHT * 9 / 14)
  love.graphics.setColor(self.background.r, self.background.g, self.background.b, self.background.a)
  love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)

  self.level:render()

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, self.message.a)
  love.graphics.printf(
    self.message.text,
    -self.size / 2,
    -self.size / 2 - 16 - gSizes["height-font-small"],
    self.size,
    "center"
  )

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
end
