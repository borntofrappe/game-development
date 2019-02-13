-- state showing the title of the game as well as the two main options to start a game/ show the high scores

-- inherit from the BaseState class
StartState = Class{__includes = BaseState}

-- initialize a variable to keep track of the selection between start and high score
-- 1 start
-- 2 high scores
highlight = 1

-- in the update function listen for a key press on the up or down key, at which point toggle between 1 and 2 in the value for highlight
-- listen also for the escape key, to pre emptively quit the game
function StartState:update(dt)
  if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
    -- ternary operator, assigning a value depending on the condition
    highlight = highlight == 1 and 2 or 1
    -- play a sound
    gSounds['paddle_hit']:play()
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

-- in the render function, display a heading with the title of the game atop two string values describing the options
function StartState:render()
  love.graphics.setFont(gFonts['humongous'])
  love.graphics.printf(
    'Breakout',
    0,
    VIRTUAL_HEIGHT / 2 - 56,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['big'])

  -- include the specified color if highlight matches the integer describing start
  if(highlight == 1) then
    love.graphics.setColor(0.4, 1, 1, 1)
  end
  love.graphics.printf(
    'START',
    0,
    VIRTUAL_HEIGHT * 3 / 4,
    VIRTUAL_WIDTH,
    'center'
  )
  -- reset the color to white
  love.graphics.setColor(1, 1, 1, 1)

  -- include the specified color if highlight matches the integer describing high scores
  if(highlight == 2) then
    love.graphics.setColor(0.4, 1, 1, 1)
  end
  love.graphics.printf(
    'HIGH SCORES',
    0,
    VIRTUAL_HEIGHT * 3 / 4 + 28,
    VIRTUAL_WIDTH,
    'center'
  )

  -- reset the color to white
  love.graphics.setColor(1, 1, 1, 1)
end