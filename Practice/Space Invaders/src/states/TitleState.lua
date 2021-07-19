TitleState = BaseState:new()

local TITLE_OFFSET_Y = -8
local TITLE_DELAY = 0.5
local TITLE_TWEEN = 1.5
local INSTRUCTIONS_INTERVAL = 0.8
local POINTS_STATE_DELAY = 9

function TitleState:enter(params)
  local highScore = params and params.highScore or 1000

  self.title = {
    ["text"] = TITLE:upper(),
    ["y"] = WINDOW_HEIGHT,
    ["y1"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight() + TITLE_OFFSET_Y,
    ["delay"] = {
      ["duration"] = TITLE_DELAY
    },
    ["tween"] = {
      ["duration"] = TITLE_TWEEN
    }
  }

  self.record = {
    ["text"] = string.upper("Hi-Score\t" .. highScore),
    ["y"] = WINDOW_PADDING,
    ["show"] = false
  }

  self.instructions = {
    ["text"] = "Press enter to play",
    ["y"] = self.title.y1 + gFonts.large:getHeight() * 2,
    ["show"] = false,
    ["interval"] = {
      ["duration"] = INSTRUCTIONS_INTERVAL,
      ["label"] = "instructions-interval"
    }
  }

  self.delay = {
    ["duration"] = POINTS_STATE_DELAY,
    ["label"] = "points-state-delay"
  }

  Timer:after(
    self.title.delay.duration,
    function()
      Timer:tween(
        self.title.tween.duration,
        {
          [self.title] = {["y"] = self.title.y1}
        },
        function()
          Timer:after(
            self.title.delay.duration,
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
                self.delay.duration,
                function()
                  Timer:remove(self.instructions.interval.label)
                  gStateMachine:change("points")
                end,
                self.delay.label
              )
            end
          )
        end
      )
    end
  )
end

function TitleState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    if self.record.show then
      Timer:remove(self.instructions.interval.label)
      Timer:remove(self.delay.label)
      gStateMachine:change("serve")
    end
  end
end

function TitleState:render()
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
