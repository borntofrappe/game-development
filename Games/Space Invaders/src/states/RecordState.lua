RecordState = Class({__includes = BaseState})

function RecordState:init()
  self.text = "You\nget\nHi-score!"

  self.delay =
    Timer.after(
    4,
    function()
      self.delay:remove()
      gStateMachine:change("title")
    end
  )
end

function RecordState:update(dt)
  Timer.update(dt)
end

function RecordState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(self.text:upper(), 0, WINDOW_HEIGHT / 2 - 36, WINDOW_WIDTH, "center")
end
