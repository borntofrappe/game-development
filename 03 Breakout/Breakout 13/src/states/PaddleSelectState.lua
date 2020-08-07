PaddleSelectState = Class({__includes = BaseState})

function PaddleSelectState:init()
  self.paddle = Paddle(VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - 32)
end

function PaddleSelectState:update(dt)
  if love.keyboard.waspressed('escape') then
    gStateMachine:change('start')
  end

  if love.keyboard.waspressed('enter') or love.keyboard.waspressed('return') then
    gStateMachine:change('serve', {
      paddle = self.paddle,
    })
  end

  if love.keyboard.waspressed('right') then
    self.paddle.color = self.paddle.color == 4 and 1 or self.paddle.color + 1
    gSounds['select']:play()
  end
  
  if love.keyboard.waspressed('left') then
    self.paddle.color = self.paddle.color == 1 and 4 or self.paddle.color - 1
    gSounds['select']:play()
  end
end

function PaddleSelectState:render()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Paddle selection',
    0,
    VIRTUAL_HEIGHT / 2 - 20,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setFont(gFonts['normal'])
  love.graphics.printf(
    'Press enter to serve',
    0,
    VIRTUAL_HEIGHT / 2 + 16,
    VIRTUAL_WIDTH,
    'center'
  )

  self.paddle:render()
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 2 - 40 - 24, VIRTUAL_HEIGHT - 32 + 8 - 12)
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH / 2 + 40, VIRTUAL_HEIGHT - 32 + 8 - 12)
end

