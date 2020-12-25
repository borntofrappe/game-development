Room = Class()

function Room:init()
  local tiles = {}
  local columns = COLUMNS
  local rows = ROWS

  for column = 1, columns do
    tiles[column] = {}
    for row = 1, rows do
      local id
      if column == 1 or column == columns or row == 1 or row == rows then
        id = ROOM_IDS.empty
      else
        id = ROOM_IDS.terrain[love.math.random(#ROOM_IDS.terrain)]
      end
      tiles[column][row] = {
        ["id"] = id,
        ["column"] = column,
        ["row"] = row
      }
    end
  end

  for column = 3, columns - 2 do
    tiles[column][2].id = ROOM_IDS.side.up[love.math.random(#ROOM_IDS.side.up)]
    tiles[column][rows - 1].id = ROOM_IDS.side.down[love.math.random(#ROOM_IDS.side.down)]
  end

  for row = 3, rows - 2 do
    tiles[2][row].id = ROOM_IDS.side.left[love.math.random(#ROOM_IDS.side.left)]
    tiles[columns - 1][row].id = ROOM_IDS.side.right[love.math.random(#ROOM_IDS.side.right)]
  end

  tiles[2][2].id = ROOM_IDS.corner["up-left"]
  tiles[columns - 1][2].id = ROOM_IDS.corner["up-right"]
  tiles[columns - 1][rows - 1].id = ROOM_IDS.corner["down-right"]
  tiles[2][rows - 1].id = ROOM_IDS.corner["down-left"]

  tiles[math.floor(columns / 2)][1].id = ROOM_IDS.door.up.closed[1]
  tiles[math.floor(columns / 2) + 1][1].id = ROOM_IDS.door.up.closed[2]
  tiles[math.floor(columns / 2)][2].id = ROOM_IDS.door.up.closed[3]
  tiles[math.floor(columns / 2) + 1][2].id = ROOM_IDS.door.up.closed[4]

  tiles[columns][math.floor(rows / 2)].id = ROOM_IDS.door.right.closed[1]
  tiles[columns][math.floor(rows / 2) + 1].id = ROOM_IDS.door.right.closed[2]
  tiles[columns - 1][math.floor(rows / 2)].id = ROOM_IDS.door.right.closed[3]
  tiles[columns - 1][math.floor(rows / 2) + 1].id = ROOM_IDS.door.right.closed[4]

  tiles[math.floor(columns / 2)][rows].id = ROOM_IDS.door.down.closed[1]
  tiles[math.floor(columns / 2) + 1][rows].id = ROOM_IDS.door.down.closed[2]
  tiles[math.floor(columns / 2)][rows - 1].id = ROOM_IDS.door.down.closed[3]
  tiles[math.floor(columns / 2) + 1][rows - 1].id = ROOM_IDS.door.down.closed[4]

  tiles[1][math.floor(rows / 2)].id = ROOM_IDS.door.left.closed[1]
  tiles[1][math.floor(rows / 2) + 1].id = ROOM_IDS.door.left.closed[2]
  tiles[2][math.floor(rows / 2)].id = ROOM_IDS.door.left.closed[3]
  tiles[2][math.floor(rows / 2) + 1].id = ROOM_IDS.door.left.closed[4]

  self.tiles = tiles
end

function Room:render()
  for i, column in pairs(self.tiles) do
    for j, cell in pairs(column) do
      love.graphics.draw(
        gTextures["tilesheet"],
        gFrames["tilesheet"][cell.id],
        (cell.column - 1) * TILE_SIZE,
        (cell.row - 1) * TILE_SIZE,
        0,
        SCALE_SPRITE,
        SCALE_SPRITE
      )
    end
  end
end
