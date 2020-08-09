LevelMaker = Class {}

function LevelMaker.createMap(level)
  local bricks = {}

  local rows = math.random(2, 4)
  local cols = math.random(4, 7)

  for row = 1, rows do
    for col = 1, cols do
      skipFlag = math.random(1, 3) == 2

      if not skipFlag then
        lockFlag = math.random(1, 10) == 2
        if lockFlag then
          brick = LockedBrick((col - 1) * 32 + (VIRTUAL_WIDTH - cols * 32) / 2, row * 16)
          table.insert(bricks, brick)
        else
          maxTier = math.min(4, math.ceil(level / 2))
          maxColor = math.min(5, math.ceil(level / 4))
          tier = math.random(1, maxTier)
          color = math.random(1, maxColor)

          powerupFlag = math.random(1, 5) == 2

          brick = Brick((col - 1) * 32 + (VIRTUAL_WIDTH - cols * 32) / 2, row * 16, tier, color, powerupFlag)
          table.insert(bricks, brick)
        end
      end
    end
  end

  return bricks
end
