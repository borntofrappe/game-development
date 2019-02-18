--[[
  paddle select state

  showing:

  - arrows
  - paddle

  allowing to:
  - select a paddle by using the left or right key
]]

-- inherit from the BaseState class
PaddleSelectState = Class{__includes = BaseState}

-- in the enter class initialize the values passed from the start state
-- this mainly to pass the values to the serve state
function PaddleSelectState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.score = params.score
  self.level = params.level
end

-- in the update function listen for a key press on a selection of keys
function PaddleSelectState:update(dt)
  -- listen for a key press on the left or right arrow, at which point change the color of the paddle
  -- in the [1-4] range
  -- ! play the appropriate sound for when the selection is not possible
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

  -- listen for a key press on the eecape key, at which point go back to the start screen
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('start')
    -- play a sound as the game moves back toward the start screen
    gSounds['confirm']:play()
  end

  -- listen for a key press on the enter key, at which point go to the serve state
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- transition to the serve state sending the the variables necessary to play the game
    gStateMachine:change('serve', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      score = self.score,
      level = self.level
    })
    -- play a sound as the game moves to the serve screen
    gSounds['select']:play()
  end

end

-- in the render function render the paddle in between the two arrows
function PaddleSelectState:render(dt)
  -- render the paddle through the :render() function
  self.paddle:render()

  -- render the arrows directly through love.graphics.draw
  -- ! by using setColor and modifying the alpha values it is possible to alter the opacity of the arrows
  love.graphics.setColor(1, 1, 1, 1)

  if self.paddle.skin == 1 then
    love.graphics.setColor(1, 1, 1, 0.5)
  end
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 2 - 80 - 12, VIRTUAL_HEIGHT - 32 - 6)
  -- remember to reset the color once it is changed
  love.graphics.setColor(1, 1, 1, 1)

  if self.paddle.skin == 4 then
    love.graphics.setColor(1, 1, 1, 0.5)
  end
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH / 2 + 80 - 12, VIRTUAL_HEIGHT - 32 - 6)
  love.graphics.setColor(1, 1, 1, 1)

  -- text instructing on how to start playing
  love.graphics.setFont(gFonts['big'])

  love.graphics.printf(
    'Select paddle',
    0,
    VIRTUAL_HEIGHT / 2 - 32,
    VIRTUAL_WIDTH,
    'center'
  )

end