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
end

-- in the update(dt) function listen for a key press on a selection of keys
function PlayState:update(dt)

  -- when pressing enter go to the game over state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('gameover')
  end
end

-- in the render() function, display a heading
function PlayState:render()
  love.graphics.print('Play', 8, 8)
end