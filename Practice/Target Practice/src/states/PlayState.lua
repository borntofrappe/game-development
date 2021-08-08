PlayState = BaseState:new()

function PlayState:enter()
  -- x for the position of the wheel/rotation point
  -- y for the bottom
  self.cannon = Cannon:new(34, WINDOW_HEIGHT)
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end
end

function PlayState:render()
  self.cannon:render()
end
