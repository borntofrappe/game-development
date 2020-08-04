StartState = Class({__includes = BaseState})

function StartState:init()
  self.choice = 1
end

function StartState:update(dt)
  if love.keyboard.waspressed('up') or love.keyboard.waspressed('down') then
    self.choice = self.choice == 1 and 2 or 1
    gSounds['paddle_hit']:play()
  end

  if love.keyboard.waspressed('escape') then
    love.event.quit()
  end
end

function StartState:render()
  love.graphics.setFont(gFonts['humongous'])
  love.graphics.printf(
    'Breakout',
    0,
    VIRTUAL_HEIGHT / 2 - 56,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts['big'])
  if self.choice == 1 then
    love.graphics.setColor(0.4, 1, 1, 1)
  end
  love.graphics.printf(
    'START',
    0,
    VIRTUAL_HEIGHT * 3 / 4,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setColor(1, 1, 1, 1)
  if self.choice == 2 then
    love.graphics.setColor(0.4, 1, 1, 1)
  end
  love.graphics.printf(
    'HIGH SCORES',
    0,
    VIRTUAL_HEIGHT * 3 / 4 + 28,
    VIRTUAL_WIDTH,
    'center'
  )

  love.graphics.setColor(1, 1, 1, 1)
end