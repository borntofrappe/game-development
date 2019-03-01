--[[
  gameover state

  showing:
    - a heading
    - the score
    - how to proceed

  allowing to:
    - go to the start state
]]

-- inherit from the BaseState class
GameoverState = Class{__includes = BaseState}

-- in the enter() function
function GameoverState:enter(params)
  self.score = params.score
end

-- in the update(dt) function listen for a key press on a selection of keys
function GameoverState:update(dt)
  -- when pressing enter go to the start state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('start')
  end
end

-- in the render() function, display the gameover message atop the score achieved by the player and how to continue
function GameoverState:render()
  -- include the strings atop an overlay matching the play state
  -- overlay centered in the page
  love.graphics.setColor(0.1, 0.17, 0.35, 0.7)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - VIRTUAL_WIDTH / 6, VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 5, VIRTUAL_WIDTH / 3, VIRTUAL_HEIGHT / 2.5, 5)
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - VIRTUAL_WIDTH / 6, VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 5, VIRTUAL_WIDTH / 3, VIRTUAL_HEIGHT / 2.5, 5)


  -- include the heading and strings of text evenly space in the overlay
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(0.42, 0.59, 0.94, 1)
  love.graphics.printf(
    'GAMEOVER',
    0,
    (VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 5) + (VIRTUAL_HEIGHT / 2.5) / 4 - 16,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['normal'])

  love.graphics.printf(
    'Score: ' .. tostring(self.score),
    0,
    (VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 5) + (VIRTUAL_HEIGHT / 2.5) / 4 * 2 - 8,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['small'])

  love.graphics.printf(
    'Press enter to continue',
    0,
    (VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 5) + (VIRTUAL_HEIGHT / 2.5) / 4 * 3 - 4,
    VIRTUAL_WIDTH,
    'center'
  )
end