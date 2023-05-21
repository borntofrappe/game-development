LevelMaker = Class {}

local ROWS_MIN = 2
local ROWS_MAX = 4

local COLUMNS_MIN = 4
local COLUMNS_MAX = 9

local SKIP_ODDS = 5 -- 1 in 5
local ALTERNATE_ODDS = 5 -- 1 in 5

function LevelMaker.createMap(level)
  local bricks = {}

  local rows = math.random(ROWS_MIN, ROWS_MAX)
  local cols = math.random(COLUMNS_MIN, COLUMNS_MAX)

  for row = 1, rows do
    local skipFlag = math.random(SKIP_ODDS) == 1
    local skipOddsOrEven = math.random(2) == 1 and 1 or 0
    local alternateFlag = math.random(ALTERNATE_ODDS) == 1

    local maxColor = math.min(BRICK_COLORS, math.ceil(level / 2)) -- 2 as a magic number
    local colors = {math.random(maxColor), math.random(maxColor)}
    local colorIndex = 1

    local maxTier = math.min(BRICK_TIERS, math.floor(level / 3)) -- 3 as a magic number

    for col = 1, cols do
      if skipFlag then
        if col % 2 == skipOddsOrEven then
          local tier = math.random(maxTier)
          local brick =
            Brick(
            (col - 1) * BRICK_WIDTH + (VIRTUAL_WIDTH - cols * BRICK_WIDTH) / 2,
            row * BRICK_HEIGHT,
            tier,
            colors[colorIndex]
          )
          table.insert(bricks, brick)

          if alternateFlag then
            colorIndex = colorIndex == 1 and 2 or 1
          end
        end
      else
        local tier = math.random(maxTier)
        local brick =
          Brick(
          (col - 1) * BRICK_WIDTH + (VIRTUAL_WIDTH - cols * BRICK_WIDTH) / 2,
          row * BRICK_HEIGHT,
          tier,
          colors[colorIndex]
        )
        table.insert(bricks, brick)

        if alternateFlag then
          colorIndex = colorIndex == 1 and 2 or 1
        end
      end
    end
  end

  return bricks
end
