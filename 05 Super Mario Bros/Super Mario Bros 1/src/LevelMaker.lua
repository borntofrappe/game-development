LevelMaker = Class {}

function LevelMaker.generate(width, height)
  local tiles = {}
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
    end

    for y = 1, height do
      local tile = {
        id = y < rows_sky and TILE_SKY or TILE_GROUND,
        topper = y == rows_sky
      }
      tiles[x][y] = tile
    end
  end

  return tiles
end
