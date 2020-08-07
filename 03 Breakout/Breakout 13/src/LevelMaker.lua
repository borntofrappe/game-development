LevelMaker = Class{}

function LevelMaker.createMap(level)
  local bricks = {}

  local rows = math.random(2, 4)
  local cols = math.random(4, 7)
  
  for row = 1, rows do
    for col = 1, cols do
      skipFlag = math.random(1, 3) == 2 and true or false

      if not skipFlag then
        maxTier = math.min(4, math.ceil(level / 2))
        maxColor = math.min(4, math.ceil(level / 4))
        tier = math.random(1, maxTier)
        color = math.random(1, maxColor)

        brick = Brick(
          (col - 1) * 32 + (VIRTUAL_WIDTH - cols * 32) / 2,
          row * 16,
          tier,
          color
        )
        table.insert(bricks, brick)
      end
    end
  end

  return bricks
end