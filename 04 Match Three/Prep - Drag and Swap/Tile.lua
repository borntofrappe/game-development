--[[
  Tile "class"
  - drawing a square at precise coordinates
  - highlighting the tile when the cursor overlaps with it
]]
Tile = {
  x = 0,
  y = 0,
  size = TILE_SIZE,
  -- table describing the color of the shape
  color = {
    r = 1,
    g = 1,
    b = 1
  },
  -- boolean describing whether the tile has been selected
  isSelected = false
}

-- initialize the item instance
function Tile:init(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end

-- in the update function check if the cursor overlaps with the tile
function Tile:update(dt)

  -- if the tile has not been already selected, proceed to detect collision
  if not self.isSelected then
    if cursor.x > self.x and cursor.x < self.x + self.size then
      if cursor.y > self.y and cursor.y < self.y + self.size then
        self.isSelected = true
      end -- cursor.y end
    end -- cursor.x end
  end -- not isSelected end

end -- Tile:update() end


-- show the tile through a square
function Tile:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)

  -- if the tile is selected include a noticeable border as a highlight
  if self.isSelected then
    love.graphics.setLineWidth(10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', self.x + 5, self.y + 5, self.size -10, self.size -10)
  end
end

-- function relating the position in the 3x3 grid based on the coordinates of the tile
function Tile:toGrid()
  return math.floor(self.x / TILE_SIZE), math.floor(self.y / TILE_SIZE)
end