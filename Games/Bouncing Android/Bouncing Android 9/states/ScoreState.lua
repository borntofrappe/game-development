ScoreState = Class({__includes = BaseState})

function ScoreState:enter(params)
  self.score = params.score
  self.android = params.android
  self.lollipopPairs = params.lollipopPairs
  self.buildings = params.buildings
  self.moon = params.moon
end

function ScoreState:update(dt)
  if love.mouse.waspressed then
    gStateMachine:change('play')
  end
end

function ScoreState:render(dt)
  for k, building in pairs(self.buildings) do
    love.graphics.draw(building.image, -building.offset, 20)
  end
  love.graphics.draw(self.moon, 50, 325)

  for k, lollipopPair in pairs(self.lollipopPairs) do
    lollipopPair:render()
  end  
  
  self.android:render()

  love.graphics.setColor(1, 0.2, 0.2, 1)
  love.graphics.rectangle('fill', 10, 10, 40, 40, 5, 5)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(self.score, 10, 18, 40, 'center')
end