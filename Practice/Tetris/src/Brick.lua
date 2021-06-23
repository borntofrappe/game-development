Brick = {}

function Brick:new(column, row, frame)
  local this = {
    ["column"] = column,
    ["row"] = row,
    ["frame"] = frame
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Brick:render()
  love.graphics.draw(gTexture, gFrames[self.frame], self.column * CELL_SIZE, self.row * CELL_SIZE)
end
