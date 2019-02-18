--[[
  gameover state

  showing:

  - gameover
  - score
  - how to proceed

  allowing to:
  - go to the start state
  - go to the enter high score state (if a high score is registered)
  - quit
]]

-- inherit from the BaseState class
GameoverState = Class{__includes = BaseState}

-- in the enter() function instantiate variables with the values received from the play state
function GameoverState:enter(params)
  self.score = params.score
  self.highScores = params.highScores
end

-- in the update(dt) function listen on a selection of key presses
function GameoverState:update(dt)
  -- when registering a click on the enter key, check if the score ranks in the top 10 scores, and if so move the game toward the enter high score screen
  -- else go to the start screen
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- create a local variable to determine whether the score is higher of any value in the table of high scores
    local isHighScore = false
    -- create a variable in which to store the index of the score in the list
    local scoreIndex = 0

    -- loop through the table of high scores received from the play state
    for i = 1, #self.highScores do
      -- check if the score is greater than a value only if it's not already a high score
      if not isHighScore then
        if self.score >= self.highScores[i].score then
          isHighScore = true
          scoreIndex = i
        end
      end
    end

    -- after the loop, consider whether a high score has been achieved
    -- if so call go to the enter high score state, passing the score and the position of the score in the list
    if isHighScore then
      gStateMachine:change('enterhighscore', {
        score = self.score,
        highScores = self.highScores,
        scoreIndex = scoreIndex
      })
      gSounds['high_score']:play()

    -- else go to the start state
    else
      gStateMachine:change('start', {
        highScores = self.highScores
      })
    end
    -- play a sound as the game moves to the start screen
    gSounds['confirm']:play()
  end

  -- when registering a click on the escape key, quit the game
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