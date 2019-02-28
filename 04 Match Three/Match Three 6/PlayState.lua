--[[
  play state

  showing:
    - a panel with the level, score, goal, timer
    - the board of tiles

  allowing to:
    - swap tiles and create matches, eventually leading up to
      - victory state, when reaching the goal [TODO]
      - gameover state, when the timer hits 0 [TODO]
]]

-- inherit from the BaseState class
PlayState = Class{__includes = BaseState}

-- in the init() function
function PlayState:init()
  -- set up a timer for the countdown
  self.time = 5
  Timer.every(1, function()
    self.time = self.time - 1
  end)
end

-- in the update(dt) function listen for a key press on a selection of keys
function PlayState:update(dt)

  -- -- when pressing enter go to the game over state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    self.time = self.time + 2
  end

  -- update the timer as long as timer is greater than 0
  if self.time > 0 then
    Timer.update(dt)
  else
    gStateMachine:change('gameover')
  end
end

-- in the render() function, display a panel with information on the current game
function PlayState:render()
  -- include the text on top of a colored rectangle
  -- ! overlay the colored rectangle with yet another overlay, to darken the color
  love.graphics.setColor(0.1, 0.17, 0.35, 0.7)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 6 - VIRTUAL_WIDTH / 8, VIRTUAL_HEIGHT / 12, VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 2, 5)
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 6 - VIRTUAL_WIDTH / 8, VIRTUAL_HEIGHT / 12, VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 2, 5)

  love.graphics.setFont(gFonts['normal'])
  love.graphics.setColor(0.42, 0.59, 0.94, 1)
  -- center the strings in the rectangle, which is itself centered around VIRTUAL_WIDTH / 6
  -- vertically spread the strings evenly in the VIRTUAL_HEIGHT / 2 tall container
  -- (VIRTUAL_HEIGHT / 2) / 5
  love.graphics.printf(
    'Level: 1',
    0,
    VIRTUAL_HEIGHT / 12 + (VIRTUAL_HEIGHT / 2) / 5 - 8,
    VIRTUAL_WIDTH / 3,
    'center'
  )
  love.graphics.printf(
    'Score: 123',
    0,
    VIRTUAL_HEIGHT / 12 + (VIRTUAL_HEIGHT / 2) / 5 * 2 - 8,
    VIRTUAL_WIDTH / 3,
    'center'
  )
  love.graphics.printf(
    'Goal: 321',
    0,
    VIRTUAL_HEIGHT / 12 + (VIRTUAL_HEIGHT / 2) / 5 * 3 - 8,
    VIRTUAL_WIDTH / 3,
    'center'
  )
  love.graphics.printf(
    'Timer: ' .. tostring(self.time),
    0,
    VIRTUAL_HEIGHT / 12 + (VIRTUAL_HEIGHT / 2) / 5 * 4 - 8,
    VIRTUAL_WIDTH / 3,
    'center'
  )
end