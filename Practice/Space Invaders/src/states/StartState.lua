StartState = BaseState:new()

local TIMER_DELAY = 0.5
local TITLE_OFFSET = -8
local INTERVAL_DURATION = 0.8
local COUNTDOWN_DURATION_MULTIPLIER = 9.5 -- odd number to have the state appear as the instructions are not shown

function StartState:enter(params)
  self.title = {
    ["text"] = TITLE:upper(),
    ["y"] = WINDOW_HEIGHT,
    ["y1"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight() + TITLE_OFFSET,
    ["tween"] = {
      ["duration"] = 1.5
    }
  }

  local highScore = params and params.highScore or 1000

  self.record = {
    ["text"] = string.upper("Hi-Score\t" .. highScore),
    ["y"] = 8,
    ["show"] = false
  }

  self.instructions = {
    ["text"] = "Press enter to play",
    ["y"] = self.title.y1 + gFonts.large:getHeight() * 2,
    ["show"] = false,
    ["interval"] = {
      ["label"] = "instructions",
      ["duration"] = INTERVAL_DURATION
    }
  }

  self.pointsCountdown = {
    ["duration"] = self.instructions.interval.duration * COUNTDOWN_DURATION_MULTIPLIER,
    ["label"] = "pointsCountdown"
  }

  Timer:after(
    TIMER_DELAY,
    function()
      Timer:tween(
        self.title.tween.duration,
        {
          [self.title] = {["y"] = self.title.y1}
        },
        function()
          Timer:after(
            TIMER_DELAY,
            function()
              self.record.show = true

              Timer:every(
                self.instructions.interval.duration,
                function()
                  self.instructions.show = not self.instructions.show
                end,
                true,
                self.instructions.interval.label
              )

              Timer:after(
                self.pointsCountdown.duration,
                function()
                  gStateMachine:change("points")
                end,
                self.pointsCountdown.label
              )
            end
          )
        end
      )
    end
  )
end

function StartState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    -- Timer:remove(self.instructions.interval.label)
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    if self.record.show then
      Timer:remove(self.instructions.interval.label)
      Timer:remove(self.pointsCountdown.label)
      gStateMachine:change("play")
    end
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  if self.record.show then
    love.graphics.setFont(gFonts.normal)
    love.graphics.setColor(0.14, 0.75, 0.38)
    love.graphics.printf(self.record.text, 0, self.record.y, WINDOW_WIDTH, "center")
  end

  if self.instructions.show then
    love.graphics.setFont(gFonts.normal)
    love.graphics.setColor(1, 0.77, 0.13)
    love.graphics.printf("Press enter to play", 0, self.instructions.y, WINDOW_WIDTH, "center")
  end
end
