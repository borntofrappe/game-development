WaitingScreenState = Class {__includes = BaseState}

function WaitingScreenState:init()
end

function WaitingScreenState:update(dt)
  if love.mouse.waspressed then
    gStateMachine:change("play")
  end

  for i, parallax in ipairs(gParallax) do
    parallax[2] = (parallax[2] + parallax[3] * dt) % WINDOW_WIDTH
  end
end

function WaitingScreenState:render()
  love.graphics.setColor(1, 1, 1)

  for i, parallax in ipairs(gParallax) do
    love.graphics.draw(gImages[parallax[1]], -parallax[2], 0)
  end

  love.graphics.draw(gImages.moon, 64, WINDOW_HEIGHT / 2)
end
