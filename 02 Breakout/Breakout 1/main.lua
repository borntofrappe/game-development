require 'src/Dependencies'

function love.load()
  love.window.setTitle('Breakout')
  
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ['small'] = love.graphics.newFont('res/fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('res/fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('res/fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('res/fonts/font.ttf', 56)
  }

  gTextures = {
    ['arrows'] = love.graphics.newImage('res/graphics/arrows.png'),
    ['background'] = love.graphics.newImage('res/graphics/background.png'),
    ['blocks'] = love.graphics.newImage('res/graphics/blocks.png'),
    ['breakout_big'] = love.graphics.newImage('res/graphics/breakout_big.png'),
    ['breakout'] = love.graphics.newImage('res/graphics/breakout.png'),
    ['hearts'] = love.graphics.newImage('res/graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('res/graphics/particle.png'),
    ['ui'] = love.graphics.newImage('res/graphics/ui.png')
  }
  
  gSounds = {
    ['brick-hit-1'] = love.audio.newSource('res/sounds/brick-hit-1.wav', 'static'),
    ['brick-hit-2'] = love.audio.newSource('res/sounds/brick-hit-2.wav', 'static'),
    ['confirm'] = love.audio.newSource('res/sounds/confirm.wav', 'static'),
    ['high_score'] = love.audio.newSource('res/sounds/high_score.wav', 'static'),
    ['hurt'] = love.audio.newSource('res/sounds/hurt.wav', 'static'),
    ['no-select'] = love.audio.newSource('res/sounds/no-select.wav', 'static'),
    ['paddle_hit'] = love.audio.newSource('res/sounds/paddle_hit.wav', 'static'),
    ['pause'] = love.audio.newSource('res/sounds/pause.wav', 'static'),
    ['recover'] = love.audio.newSource('res/sounds/recover.wav', 'static'),
    ['score'] = love.audio.newSource('res/sounds/score.wav', 'static'),
    ['select'] = love.audio.newSource('res/sounds/select.wav', 'static'),
    ['victory'] = love.audio.newSource('res/sounds/victory.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('res/sounds/wall_hit.wav', 'static'),

    ['music'] = love.audio.newSource('res/sounds/music.wav', 'static')
  }

  gFrames = {
    ['paddles'] = GenerateQuadsPaddles(gTextures['breakout'])
  }

  gStateMachine = StateMachine({
    ['start'] = function() return StartState() end,
    ['play'] = function() return PlayState() end
  })

  gStateMachine:change('start')

  love.keyboard.keypressed = {}
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
  return love.keyboard.keypressed[key]
end

function love.update(dt)
  gSounds['music']:setLooping(true)
  gSounds['music']:play()

  gStateMachine:update(dt)

  love.keyboard.keypressed = {}
end

function love.draw()
  push:start()

  background_width = gTextures['background']:getWidth()
  background_height = gTextures['background']:getHeight()

  love.graphics.draw(
    gTextures['background'],
    0,
    0,
    0,
    VIRTUAL_WIDTH / background_width,
    VIRTUAL_HEIGHT / background_height
  )

  gStateMachine:render()

  displayFPS()

  push:finish()

end

function displayFPS()
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 8, 8)
end