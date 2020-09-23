Tile = Class {}

function Tile:init(def)
  self.x = def.x
  self.y = def.y
  self.width = TILE_SIZE
  self.height = TILE_SIZE

  self.id = def.id

  self.tileset = def.tileset
  self.isTopper = def.isTopper
  self.topperset = def.topperset
end

function Tile:render()
  love.graphics.draw(
    gTextures["tiles"],
    gFrames["tiles"][self.tileset][self.id],
    (self.x - 1) * self.width,
    (self.y - 1) * self.height
  )

  if self.isTopper then
    love.graphics.draw(
      gTextures["tops"],
      gFrames["tops"][self.topperset][1],
      (self.x - 1) * self.width,
      (self.y - 1) * self.height
    )
  end
end
