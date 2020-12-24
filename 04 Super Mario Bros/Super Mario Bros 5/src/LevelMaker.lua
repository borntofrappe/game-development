LevelMaker = Class {}

function LevelMaker.generate(width, height)
  local tiles = {}
  local objects = {}

  local tileset = math.random(#gFrames["tiles"])
  local topperset = math.random(#gFrames["tops"])
  local colorBushesAndCacti = math.random(#gFrames["bushes_and_cacti"])

  for x = 1, width do
    tiles[x] = {}

    local rows_sky = ROWS_SKY

    local isChasm = math.random(5) == 1
    if isChasm then
      rows_sky = height
    else
      local isPillar = math.random(5) == 1
      if isPillar then
        rows_sky = rows_sky - 2
      end

      local hasBushOrCactus = math.random(5) == 1
      if hasBushOrCactus then
        local variety = math.random(#gFrames["bushes_and_cacti"][colorBushesAndCacti])
        table.insert(
          objects,
          GameObject(
            {
              x = x,
              y = rows_sky - 1,
              texture = "bushes_and_cacti",
              color = colorBushesAndCacti,
              variety = variety
            }
          )
        )
      end
    end

    for y = 1, height do
      local tile =
        Tile(
        {
          x = x,
          y = y,
          id = y < rows_sky and TILE_SKY or TILE_GROUND,
          tileset = tileset,
          isTopper = y == rows_sky,
          topperset = topperset
        }
      )

      tiles[x][y] = tile
    end
  end

  local tileMap = TileMap(width, height)
  tileMap.tiles = tiles

  local level =
    GameLevel(
    {
      objects = objects,
      tileMap = tileMap
    }
  )
  return level
end
