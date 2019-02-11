-- state showing the title screen
-- introducing the game and instructing on how to proceed

-- inherit from the BaseState class
TitleScreenState = Class{__includes = BaseState}

-- in the update(dt) function listen for a press on the enter key
-- if so call the global state machine variable to change the state to the countdown state
function TitleScreenState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

-- in the render function, display the title of the game and how to proceed
-- precede each string with the font designed to match the purpose of the text
function TitleScreenState:render()
  love.graphics.setFont(bigFont)
  love.graphics.printf(
    'Flippy Bird',
    0,
    VIRTUAL_HEIGHT / 3 - 24,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(normalFont)
  love.graphics.printf(
    'Press enter to play',
    0,
    VIRTUAL_HEIGHT / 2 - 8,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(smallFont)
  love.graphics.printf(
    'Press q to quit, anytime',
    0,
    -- display the text just above the 16 height ground
    VIRTUAL_HEIGHT - 16 - 8,
    VIRTUAL_WIDTH,
    'center'
  )

end
