RoundState = Class({__includes = BaseState})

function RoundState:enter(params)
  self.round = params and params.round or 1

  self.round = self.round < 10 and "0" .. self.round or self.round
  Timer.after(
    2.5,
    function()
      gStateMachine:change(
        "play",
        {
          round = self.round
        }
      )
    end
  )
end

function RoundState:update(dt)
  Timer.update(dt)
end

function RoundState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(36 / 255, 191 / 255, 97 / 255, 1)
  love.graphics.printf(
    string.upper("Round\n" .. self.round .. "\nReady!"),
    0,
    WINDOW_HEIGHT / 2 - 32,
    WINDOW_WIDTH,
    "center"
  )
end