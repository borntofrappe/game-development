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


-- in the enter() function initialize the values passed from the paddle select state
function ServeState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.score = params.score
  self.level = params.level
  self.highScores = params.highScores

  -- initialize also an instance of the ball class
  self.ball = Ball{}
  -- change the skin of the ball
  self.ball.skin = math.random(7)
end


-- in the update(dt) function update the position of the paddle and make the ball stick to said element
function ServeState:update(dt)
  self.paddle:update(dt)

  -- have the ball stick on the top center of the paddle
  self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
  self.ball.y = self.paddle.y - self.ball.height

  -- when registering a click on the escape key, go back to the start state
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('start', {
      highScores = self.highScores
    })
    gSounds['confirm']:play()
  end

  -- when registering a click on the enter key, go to the play state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      maxHealth = self.maxHealth,
      score = self.score,
      level = self.level,
      ball = self.ball,
      highScores = self.highScores
    })
    gSounds['select']:play()
  end
end

-- in the render() function render the graphics of the game
function ServeState:render(dt)
  -- paddle
  self.paddle:render()
  -- ball
  self.ball:render()

  -- text relating the current level
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Level ' .. tostring(self.level),
    0,
    VIRTUAL_HEIGHT / 2 - 48,
    VIRTUAL_WIDTH,
    'center'
  )

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
  displayHealth(self.health, self.maxHealth)
end