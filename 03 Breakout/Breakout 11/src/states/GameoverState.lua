--[[
  gameover state

  showing:

  - gameover
  - score
  - how to proceed

  allowing to:
  - go to the start state
  - quit
]]

-- inherit from the BaseState class
GameoverState = Class{__includes = BaseState}

-- in the enter function instantiate self.score with the score received from the play state
function GameoverState:enter(params)
  self.score = params.score
end

-- in the update(dt) function listen on a selection of key presses
function GameoverState:update(dt)
  -- when pressing enter check if the score ranks in the top 10 scores, and if so move the game toward the enter high score screen
  -- else go to the start screen
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- create a local variable to determine whether the score is higher of any value in the global table of high scores
    local isHighScore = false
    -- create a variable to only consider the rows with numbers
    local isScore = false
    -- create a variable to consider each successive score
    local counter = 1
    -- create a variable in which to store the index of the score in the list
    local scoreIndex = 0

    -- read through the list and update isHighScore and scoreIndex only if necesary
    for line in love.filesystem.lines('breakout.lst') do
      -- run the logic only if the isHighScore flag is set to false
      if not isHighScore then
        -- check only the line containing numbers
        if isScore then
          -- check if the score of the game is higher of the value described by the row
          if self.score >= tonumber(line) then
            isHighScore = true
            scoreIndex = counter
          end

          -- update counter to consider the following score
          counter = counter + 1
        end

        -- always set isScore to the opposite, identifying scores every other round
        isScore = not isScore
      end
    end


    -- after the loop, consider whether a high score has been achieved
    -- if so call the enter high score state, passing the score and the position of the score in the list
    if isHighScore then
      gStateMachine:change('enterhighscore', {
        score = self.score,
        scoreIndex = scoreIndex
      })

    -- else call the play state
    else
      gStateMachine:change('start')
    end
    -- play a sound as the game moves to the start screen
    gSounds['confirm']:play()
  end

  -- when pressing escape quit the game
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end


-- in the render function display the gameover text atop the score
function GameoverState:render()
  love.graphics.setFont(gFonts['humongous'])
  love.graphics.printf(
    'GAME OVER',
    0,
    VIRTUAL_HEIGHT / 3 - 28,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Score: ' .. tostring(self.score),
    0,
    VIRTUAL_HEIGHT / 2 - 8,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['normal'])
  love.graphics.printf(
    'Press enter to continue',
    0,
    VIRTUAL_HEIGHT * 3 / 4,
    VIRTUAL_WIDTH,
    'center'
  )
end