PlayState = BaseState:new()

function PlayState:enter()
  -- x for the position of the wheel/rotation point
  -- y for the bottom
  self.cannon = Cannon:new(34 + 20, WINDOW_HEIGHT - 20)
  self.terrain = Terrain:new(self.cannon)
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  -- debugging
  if love.keyboard.waspressed("tab") then
    self.terrain = Terrain:new(self.cannon)
  end
end

function PlayState:render()
  self.cannon:render()
  self.terrain:render()
end
