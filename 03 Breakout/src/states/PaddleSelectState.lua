--[[
  paddle select state

  showing:

  - arrows
  - paddle

  allowing to:
  - select a paddle by using the left or right key
  - go to serve state
]]

-- inherit from the BaseState class
PaddleSelectState = Class{__includes = BaseState}

-- in the enter() function initialize the values passed from the start state
-- this mainly to pass the values to the serve state
function PaddleSelectState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.maxHealth = params.maxHealth
  self.score = params.score
  self.level = params.level
  self.highScores = params.highScores
end


-- in the update(dt) function listen for a key press on a selection of keys
function PaddleSelectState:update(dt)
  -- when registering a click on the left or right arrow, change the color of the paddle in the [1-4] range
  -- change the skin of the paddle if within the specified range, else play the sound highlighting the boundary of the range
  if love.keyboard.wasPressed('left') then
    if self.paddle.skin > 1 then
      self.paddle.skin = self.paddle.skin - 1
      gSounds['select']:play()
    else
      gSounds['no-select']:play()
    end
  end

  if love.keyboard.wasPressed('right') then
    if self.paddle.skin < 4 then
      self.paddle.skin = self.paddle.skin + 1
      gSounds['select']:play()
    else
      gSounds['no-select']:play()
    end
  end

  -- when registering a click on the escape key, go back to the start screen
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('start', {
      highScores = self.highScores
    })
    gSounds['confirm']:play()
  end

  -- when registering a click on the enter key, go to the serve state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('serve', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      maxHealth = self.maxHealth,
      score = self.score,
      level = self.level,
      highScores = self.highScores
    })
    gSounds['confirm']:play()
  end
end

-- in the render() function render the paddle in between two arrows
function PaddleSelectState:render(dt)
  -- render the paddle through the paddle class
  self.paddle:render()

  -- render the arrows directly through love.graphics.draw
  -- ! by using setColor and modifying the alpha values it is possible to alter the opacity of the arrows
  love.graphics.setColor(1, 1, 1, 1)

  if self.paddle.skin == 1 then
    love.graphics.setColor(1, 1, 1, 0.4)
  end
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 2 - 80 - 12, VIRTUAL_HEIGHT - 32 - 6)
  -- reset the opacity once it is changed
  love.graphics.setColor(1, 1, 1, 1)

  if self.paddle.skin == 4 then
    love.graphics.setColor(1, 1, 1, 0.4)
  end
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH / 2 + 80 - 12, VIRTUAL_HEIGHT - 32 - 6)
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Select paddle',
    0,
    VIRTUAL_HEIGHT / 2 - 32,
    VIRTUAL_WIDTH,
    'center'
  )
end