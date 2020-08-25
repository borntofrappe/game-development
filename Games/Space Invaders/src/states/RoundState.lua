RoundState = Class({__includes = BaseState})

function RoundState:enter(params)
  self.round = params and params.round or 1

  self.roundZero = self.round < 10 and "0" .. self.round or tostring(self.round)
  self.roundText = "Round\n" .. self.roundZero .. "\nReady!"

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
  love.graphics.printf(self.roundText:upper(), 0, WINDOW_HEIGHT / 2 - 30, WINDOW_WIDTH, "center")
end
