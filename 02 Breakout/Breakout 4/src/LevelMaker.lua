LevelMaker = Class {}

function LevelMaker:createMap()
  local bricks = {}

  local rows = math.random(2, 5)
  local cols = math.random(5, 10)

  for row = 1, rows do
    for col = 1, cols do
      brick = Brick((col - 1) * 32 + (VIRTUAL_WIDTH - cols * 32) / 2, row * 16)
      table.insert(bricks, brick)
    end
  end

  return bricks
end
