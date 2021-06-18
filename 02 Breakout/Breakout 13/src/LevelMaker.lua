LevelMaker = Class {}

function LevelMaker.createMap(level)
  local bricks = {}

  local rows = math.random(2, 4)
  local cols = math.random(5, 9)

  for row = 1, rows do
    local skipFlag = math.random(1, 5) == 1
    local skipOddsOrEven = math.random(2) == 1 and 1 or 0
    local alternateFlag = math.random(1, 5) == 1

    local maxColor = math.min(5, math.ceil(level / 2))
    local colors = {math.random(1, maxColor), math.random(1, maxColor)}
    local colorIndex = 1

    local maxTier = math.min(4, math.floor(level / 3))

    for col = 1, cols do
      if skipFlag then
        if col % 2 == skipOddsOrEven then
          local tier = math.random(1, maxTier)
          local brick = Brick((col - 1) * 32 + (VIRTUAL_WIDTH - cols * 32) / 2, row * 16, tier, colors[colorIndex])
          table.insert(bricks, brick)

          if alternateFlag then
            colorIndex = colorIndex == 1 and 2 or 1
          end
        end
      else
        local tier = math.random(1, maxTier)
        local brick = Brick((col - 1) * 32 + (VIRTUAL_WIDTH - cols * 32) / 2, row * 16, tier, colors[colorIndex])
        table.insert(bricks, brick)

        if alternateFlag then
          colorIndex = colorIndex == 1 and 2 or 1
        end
      end
    end
  end

  return bricks
end
