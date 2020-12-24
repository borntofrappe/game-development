Tile = Class {}

function Tile:init(column, row, id)
  self.column = column
  self.row = row
  self.id = id
end

function Tile:render()
  love.graphics.draw(
    gTextures["sheet"],
    gFrames["sheet"][self.id],
    (self.column - 1) * TILE_SIZE,
    (self.row - 1) * TILE_SIZE
  )
end
