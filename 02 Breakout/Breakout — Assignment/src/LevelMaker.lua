LevelMaker = Class {}

local ROWS_MIN = 2
local ROWS_MAX = 4

local COLUMNS_MIN = 4
local COLUMNS_MAX = 7

local SKIP_ODDS = 3 -- 1 in 3
local LOCK_ODDS = 15 -- 1 in 15
local POWERUP_ODDS = 7 -- 1 in 7

function LevelMaker.createMap(level)
  local bricks = {}

  local rows = math.random(ROWS_MIN, ROWS_MAX)
  local cols = math.random(COLUMNS_MIN, COLUMNS_MAX)

  for row = 1, rows do
    for col = 1, cols do
      skipFlag = math.random(SKIP_ODDS) == 1

      if not skipFlag then
        lockFlag = math.random(LOCK_ODDS) == 1
        if lockFlag then
          brick = LockedBrick((col - 1) * BRICK_WIDTH + (VIRTUAL_WIDTH - cols * BRICK_WIDTH) / 2, row * BRICK_HEIGHT)
          table.insert(bricks, brick)
        else
          maxTier = math.min(BRICK_TIERS, math.ceil(level / 2)) -- magic numbers
          maxColor = math.min(BRICK_COLORS, math.ceil(level / 4)) -- magic numbers
          tier = math.random(maxTier)
          color = math.random(maxColor)

          powerupFlag = math.random(POWERUP_ODDS) == 1

          brick =
            Brick(
            (col - 1) * BRICK_WIDTH + (VIRTUAL_WIDTH - cols * BRICK_WIDTH) / 2,
            row * BRICK_HEIGHT,
            tier,
            color,
            powerupFlag
          )
          table.insert(bricks, brick)
        end
      end
    end
  end

  return bricks
end
