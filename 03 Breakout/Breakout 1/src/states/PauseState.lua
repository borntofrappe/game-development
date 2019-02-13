-- state showing the pause screen

-- inherit from the BaseState class
PauseState = Class{__includes = BaseState}

-- in the enter function create a field storing the horizontal coordinate of the paddle
function PauseState:enter(params)
  self.x = params.x
end

-- -- in the update functionlisten for a selection of keys
function PauseState:update(dt)
  -- listen for a key press on the enter key, at which point go back to the play state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- send back the horizontal coordinate to the play state
    gStateMachine:change('play', {
      x = self.x
    })
    -- play a sound as the game moves to the play screen
    gSounds['confirm']:play()
  end

end

-- in the render function, show text describing the pause screen and how to go back playing
function PauseState:render()
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Pause',
    0,
    VIRTUAL_HEIGHT / 3,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['normal'])
  love.graphics.printf(
    'Press enter to resume playing',
    0,
    VIRTUAL_HEIGHT / 2 - 8,
    VIRTUAL_WIDTH,
    'center'
  )

end