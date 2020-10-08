PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.tiles = PlayState:initTiles()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateStack:pop()
    gStateStack:push(StartState())
  end

  if love.keyboard.wasPressed("d") or love.keyboard.wasPressed("D") then
    gStateStack:push(DialogueState())
  end
end

function PlayState:render()
  for k, tile in pairs(self.tiles) do
    tile:render()
  end
end

function PlayState:initTiles()
  local tiles = {}

  for column = 1, COLUMNS do
    for row = 1, ROWS do
      table.insert(tiles, Tile(column, row, TILE_BACKGROUND))
      if row > ROWS - 5 then
        table.insert(tiles, Tile(column, row, TILE_GRASS))
      end
    end
  end

  return tiles
end
