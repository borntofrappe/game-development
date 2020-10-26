Brick = {}
Brick.__index = Brick

function Brick:new(def)
  local def =
    def or
    {
      ["column"] = 1,
      ["row"] = 1,
      ["color"] = math.random(#gFrames["tiles"])
    }

  this = {
    ["column"] = def.column,
    ["row"] = def.row,
    ["color"] = def.color
  }

  setmetatable(this, self)

  return this
end

function Brick:render()
  love.graphics.draw(
    gTextures["tiles"],
    gFrames["tiles"][self.color],
    (self.column - 1) * TILE_SIZE,
    (self.row - 1) * TILE_SIZE
  )
end
