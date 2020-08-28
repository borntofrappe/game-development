GameoverState = Class({__includes = BaseState})

function GameoverState:init()
  self.text = "Gameover"
end

function GameoverState:enter(params)
  self.delay =
    Timer.after(
    3,
    function()
      self.delay:remove()
      if params.score >= gRecord then
        gRecord = params.score
        gStateMachine:change("record")
      else
        gStateMachine:change("title")
      end
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
