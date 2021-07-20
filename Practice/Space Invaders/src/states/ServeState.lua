ServeState = BaseState:new()

local PLAY_STATE_DELAY = 1.5

function ServeState:enter(params)
  self.interval =
    params and params.interval or
    {
      ["duration"] = 0.9,
      ["min"] = 0.4,
      ["change"] = 0.1,
      ["label"] = "update-interval"
    }

  self.data = params and params.data or Data:new()
  self.invaders = params and params.invaders or Invaders:new(self.interval.duration / (INVADER_TYPES + 1))

  self.title = string.upper("Round\n" .. string.format("%02d", self.data.round) .. "\nReady!")

  self.delay = {
    ["duration"] = PLAY_STATE_DELAY
  }

  Timer:after(
    self.delay.duration,
    function()
      gStateMachine:change(
        "play",
        {
          ["interval"] = self.interval,
          ["data"] = self.data,
          ["invaders"] = self.invaders,
          ["setupInterval"] = true
        }
      )
    end
  )
end

function ServeState:update(dt)
  Timer:update(dt)
end

function ServeState:render()
  love.graphics.setColor(0.14, 0.75, 0.38)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.title, 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() * 1.5, WINDOW_WIDTH, "center")
end
