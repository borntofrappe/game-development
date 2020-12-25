-- good luck
Timer = require "Timer"

COLUMNS = 18
ROWS = 13

TILE_SIZE = 16
SCALE_SPRITE = 2

WINDOW_WIDTH = COLUMNS * TILE_SIZE * SCALE_SPRITE
WINDOW_HEIGHT = ROWS * TILE_SIZE * SCALE_SPRITE

ROOM_IDS = {
  ["empty"] = 21,
  ["door"] = {
    ["up"] = {
      ["closed"] = {134, 135, 153, 154},
      ["opened"] = {98, 99, 117, 118}
    },
    ["right"] = {
      ["closed"] = {175, 194, 174, 193},
      ["opened"] = {173, 192, 172, 191}
    },
    ["down"] = {
      ["closed"] = {235, 236, 216, 217},
      ["opened"] = {160, 161, 141, 142}
    },
    ["left"] = {
      ["closed"] = {219, 238, 220, 239},
      ["opened"] = {181, 200, 182, 201}
    }
  },
  ["corner"] = {
    ["up-left"] = 4,
    ["up-right"] = 5,
    ["down-right"] = 24,
    ["down-left"] = 23
  },
  ["side"] = {
    ["up"] = {58, 59, 60},
    ["right"] = {78, 97, 116},
    ["down"] = {79, 80, 81},
    ["left"] = {77, 96, 115}
  },
  ["terrain"] = {
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    64,
    65,
    66,
    67,
    68,
    69,
    70,
    88,
    89,
    107,
    108
  }
}

ROOM_TRANSLATIONS = {
  ["up"] = {
    ["x"] = 0,
    ["y"] = -WINDOW_HEIGHT
  },
  ["right"] = {
    ["x"] = WINDOW_WIDTH,
    ["y"] = 0
  },
  ["down"] = {
    ["x"] = 0,
    ["y"] = WINDOW_HEIGHT
  },
  ["left"] = {
    ["x"] = -WINDOW_WIDTH,
    ["y"] = 0
  }
}
TWEEN_DURATION = 1

function GenerateQuads(atlas)
  local sheetWidth = atlas:getWidth() / TILE_SIZE
  local sheetHeight = atlas:getHeight() / TILE_SIZE

  local counter = 1
  local quads = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      local sprite = love.graphics.newQuad(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE, atlas:getDimensions())
      quads[counter] = sprite
      counter = counter + 1
    end
  end

  return quads
end

function love.load()
  love.window.setTitle("Scrolling")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
  love.graphics.setDefaultFilter("nearest")
  gTexture = love.graphics.newImage("tilesheet.png")
  gFrames = GenerateQuads(gTexture)

  currentRoom = newRoom()
  nextRoom = nil

  translate = {
    ["currentRoom"] = {
      ["x"] = 0,
      ["y"] = 0
    },
    ["nextRoom"] = {
      ["x"] = 0,
      ["y"] = 0
    }
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "up" or key == "right" or key == "down" or key == "left" then
    if not nextRoom then
      nextRoom = newRoom()
      local translation = ROOM_TRANSLATIONS[key]

      translate.nextRoom.x = translation.x
      translate.nextRoom.y = translation.y
      Timer:tween(
        TWEEN_DURATION,
        {
          [translate.currentRoom] = {["x"] = translation.x * -1, ["y"] = translation.y * -1}
        }
      )
      Timer:after(
        TWEEN_DURATION + 0.1,
        function()
          currentRoom = nextRoom
          nextRoom = nil
          translate.currentRoom.x = 0
          translate.currentRoom.y = 0
          translate.nextRoom.x = 0
          translate.nextRoom.y = 0
        end
      )
    end
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.translate(translate.currentRoom.x, translate.currentRoom.y)
  for i, column in pairs(currentRoom) do
    for j, cell in pairs(column) do
      love.graphics.draw(
        gTexture,
        gFrames[cell.id],
        (cell.column - 1) * TILE_SIZE * SCALE_SPRITE,
        (cell.row - 1) * TILE_SIZE * SCALE_SPRITE,
        0,
        SCALE_SPRITE,
        SCALE_SPRITE
      )
    end
  end

  if nextRoom then
    love.graphics.translate(translate.nextRoom.x, translate.nextRoom.y)

    for i, column in pairs(nextRoom) do
      for j, cell in pairs(column) do
        love.graphics.draw(
          gTexture,
          gFrames[cell.id],
          (cell.column - 1) * TILE_SIZE * SCALE_SPRITE,
          (cell.row - 1) * TILE_SIZE * SCALE_SPRITE,
          0,
          SCALE_SPRITE,
          SCALE_SPRITE
        )
      end
    end
  end
end

function love.update(dt)
  Timer:update(dt)
end

function newRoom()
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

  tiles[math.floor(columns / 2)][1].id = ROOM_IDS.door.up["opened"][1]
  tiles[math.floor(columns / 2) + 1][1].id = ROOM_IDS.door.up["opened"][2]
  tiles[math.floor(columns / 2)][2].id = ROOM_IDS.door.up["opened"][3]
  tiles[math.floor(columns / 2) + 1][2].id = ROOM_IDS.door.up["opened"][4]

  tiles[columns][math.floor(rows / 2)].id = ROOM_IDS.door.right["opened"][1]
  tiles[columns][math.floor(rows / 2) + 1].id = ROOM_IDS.door.right["opened"][2]
  tiles[columns - 1][math.floor(rows / 2)].id = ROOM_IDS.door.right["opened"][3]
  tiles[columns - 1][math.floor(rows / 2) + 1].id = ROOM_IDS.door.right["opened"][4]

  tiles[math.floor(columns / 2)][rows].id = ROOM_IDS.door.down["opened"][1]
  tiles[math.floor(columns / 2) + 1][rows].id = ROOM_IDS.door.down["opened"][2]
  tiles[math.floor(columns / 2)][rows - 1].id = ROOM_IDS.door.down["opened"][3]
  tiles[math.floor(columns / 2) + 1][rows - 1].id = ROOM_IDS.door.down["opened"][4]

  tiles[1][math.floor(rows / 2)].id = ROOM_IDS.door.left["opened"][1]
  tiles[1][math.floor(rows / 2) + 1].id = ROOM_IDS.door.left["opened"][2]
  tiles[2][math.floor(rows / 2)].id = ROOM_IDS.door.left["opened"][3]
  tiles[2][math.floor(rows / 2) + 1].id = ROOM_IDS.door.left["opened"][4]

  return tiles
end
