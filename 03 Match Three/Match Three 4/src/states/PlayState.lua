PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.board = Board(ROWS, COLUMNS)
end

function PlayState:update(dt)
  -- temporary, ideally you'd move to the title screen
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  self.board:update(dt)
end

function PlayState:render()
  love.graphics.translate(VIRTUAL_WIDTH - COLUMNS * TILE_WIDTH - 32, VIRTUAL_HEIGHT / 2 - ROWS * TILE_HEIGHT / 2)

  self.board:render()
end
