GameoverState = Class({__includes = BaseState})

function GameoverState:init()
  self.text = "Gameover"

  Timer.after(
    5,
    function()
      gStateMachine:change("title")
    end
  )
end

function GameoverState:update(dt)
  Timer.update(dt)
end

function GameoverState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT / 2 - 12, WINDOW_WIDTH, "center")
end
