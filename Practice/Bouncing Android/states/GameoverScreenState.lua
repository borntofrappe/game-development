GameoverScreenState = Class {__includes = BaseState}

function GameoverScreenState:enter(params)
  self.score = params.score
  self.android = params.android
  self.lollipopPairs = params.lollipopPairs
end

function GameoverScreenState:update(dt)
  if love.mouse.waspressed then
    gStateMachine:change("play")
  end
end

function GameoverScreenState:render()
  love.graphics.setColor(1, 1, 1)

  for i, parallax in ipairs(gParallax) do
    love.graphics.draw(gImages[parallax[1]], -parallax[2], 0)
  end

  love.graphics.draw(gImages.moon, 64, WINDOW_HEIGHT / 2)

  for k, lollipopPair in pairs(self.lollipopPairs) do
    lollipopPair:render()
  end

  self.android:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  love.graphics.print(self.score, 8, 8)
end
