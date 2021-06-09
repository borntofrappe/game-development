GameoverScreenState = Class {__includes = BaseState}

function GameoverScreenState:init()
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

  love.graphics.setFont(gFonts.normal)
  love.graphics.print("here you'd show the score", 8, 8)
end
