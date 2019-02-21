--[[
  start state

  showing:

  - game title
  - selection between starting the game or checking the high scores

  allowing to:
  - go to the paddle select state
  - go to the high score state
  - quit the game
]]

-- inherit from the BaseState class
StartState = Class{__includes = BaseState}

-- initialize a variable to keep track of the selection between start and high score
-- 1 start
-- 2 high scores
local highlight = 1

-- in the render() function initialize a variable to keep track of the high score table
function StartState:enter(params)
  self.highScores = params.highScores
end

-- in the update(dt) function listen for a key press on a selection of keys
function StartState:update(dt)
  -- when registering a click on the up or down key, toggle between 1 and 2 for the value for highlight
  if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
    -- ternary operator, assigning a value depending on the condition
    highlight = highlight == 1 and 2 or 1

    -- play a matching sound
    gSounds['select']:play()
  end

  -- when registering a click on the escape key, quit the game
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- when registering a click on the enter key, go to the paddle select state or the high score state
  -- this depending on the value of highlight
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- option 1, start game, go to paddle select state
    if highlight == 1 then
      -- include all necessary values in the second argument of the StateMachine:change() function
      gStateMachine:change('paddleselect', {
        paddle = Paddle(1),
        bricks = LevelMaker.createMap(1),
        health = 3,
        maxHealth = 3,
        score = 0,
        level = 1,
        highScores = self.highScores
      })
    -- option 2, high score, go to high score state
    else
      gStateMachine:change('highscore', {
        highScores = self.highScores
      })
    end

    -- play a matching sound
    gSounds['confirm']:play()
  end
end

-- in the render() function, display a heading with the title of the game atop two string values describing the options
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
  -- specify a different color depending on the value of highlight
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