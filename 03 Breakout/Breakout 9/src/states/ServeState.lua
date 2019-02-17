--[[
  serve state

  showing:

  - bricks
  - ball
  - paddle
  - hearts
  - score

  allowing to:
  - move the paddle (the ball follows this movement)
  - go to the play state
  - go to the start state
]]

-- inherit from the BaseState class
ServeState = Class{__includes = BaseState}

-- in the enter class initialize the values passed from the start state
function ServeState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.score = params.score
  self.level = params.level

  -- initialize also an instance of the ball class
  self.ball = Ball{}
  -- change the skin of the ball
  self.ball.skin = math.random(7)
end

-- in the update function update the position of the paddle and make the ball stick to said element
function ServeState:update(dt)
  self.paddle:update(dt)

  self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
  self.ball.y = self.paddle.y - self.ball.height


  -- listen for a key press on the escape key, at which point go back to the start screen
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('start')
    -- play a sound as the game moves back toward the start screen
    gSounds['confirm']:play()
  end

  -- listen for a key press on the enter key, at which point go to the play state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- transition to the play state sending the the variables necessary to play the game
    gStateMachine:change('play', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      score = self.score,
      level = self.level,
      ball = self.ball
    })
    -- play a sound as the game moves to the pause screen
    gSounds['select']:play()
  end

end

-- in the render function render the graphics of the game
function ServeState:render(dt)
  -- paddle, ball
  self.paddle:render()
  self.ball:render()

  -- text instructing on how to start playing
  love.graphics.setFont(gFonts['normal'])

  love.graphics.printf(
    'Press enter to play',
    0,
    VIRTUAL_HEIGHT / 2 - 8,
    VIRTUAL_WIDTH,
    'center'
  )

  -- bricks
  for k, brick in pairs(self.bricks) do
    brick:render()
  end

  -- display the score
  displayScore(self.score)

  -- display the hearts
  displayHealth(self.health)

end