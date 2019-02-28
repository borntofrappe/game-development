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

-- in the init() function
function GameoverState:init()
end

-- in the update(dt) function listen for a key press on a selection of keys
function GameoverState:update(dt)
  -- when pressing enter go to the start state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('start')
  end
end

-- in the render() function, display a heading
function GameoverState:render()
  love.graphics.print('Gamover', 8, 8)
end