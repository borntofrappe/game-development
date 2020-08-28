Alien = Class {}

function Alien:init(row, column)
  self.row = row
  self.column = column
  self.x = 16 + (self.column - 1) * (ALIEN_GAP_X + ALIEN_WIDTH)
  self.y = 76 + (self.row - 1) * (ALIEN_GAP_Y + ALIEN_HEIGHT)
  self.width = ALIEN_WIDTH
  self.height = ALIEN_HEIGHT

  self.type = row == 1 and 3 or row <= 3 and 2 or 1

  self.variant = 1

  self.inPlay = true

  self.direction = 1
  self.dx = ALIEN_JUMP_X
  self.dy = ALIEN_JUMP_Y

  self.lastRow = self.row == ROWS
  self.bounceFirst = self.row == 1 and self.column == 1
  self.bounceLast = self.row == 1 and self.column == COLUMNS
  self.isLast = self.row == ROWS and self.column == column
end

function Alien:render()
  if self.inPlay then
    love.graphics.draw(gTextures["spritesheet"], gFrames["aliens"][self.type][self.variant], self.x, self.y)
  end
end
