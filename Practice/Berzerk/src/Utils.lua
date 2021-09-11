function GenerateQuadsPlayer(atlas)
  local x = 0
  local y = 0

  --[[
    1 idle
    2,3 walk
    4 shoot
    5 lose
  ]]
  local types = 5

  local quads = {}

  for i = 1, types do
    table.insert(
      quads,
      love.graphics.newQuad(x + (i - 1) * SPRITE_SIZE, y, SPRITE_SIZE, SPRITE_SIZE, atlas:getDimensions())
    )
  end

  return quads
end

function GenerateQuadsEnemy(atlas)
  local states = {
    ["idle"] = {
      ["frames"] = 8,
      ["x"] = 0,
      ["y"] = 8
    },
    ["walk-down"] = {
      ["frames"] = 3,
      ["x"] = 0,
      ["y"] = 16
    },
    ["walk-right"] = {
      ["frames"] = 3,
      ["x"] = 0,
      ["y"] = 24
    },
    ["walk-up"] = {
      ["frames"] = 3,
      ["x"] = 0,
      ["y"] = 32
    },
    ["walk-left"] = {
      ["frames"] = 3,
      ["x"] = 0,
      ["y"] = 40
    },
    ["shoot"] = {
      ["frames"] = 1,
      ["x"] = 0,
      ["y"] = 8
    },
    ["explode"] = {
      ["frames"] = 2,
      ["x"] = 48,
      ["y"] = 0
    }
  }

  local quads = {}

  for key, state in pairs(states) do
    local x = state.x
    local y = state.y
    local frames = state.frames

    quads[key] = {}
    for frame = 1, frames do
      table.insert(
        quads[key],
        love.graphics.newQuad(x + (frame - 1) * SPRITE_SIZE, y, SPRITE_SIZE, SPRITE_SIZE, atlas:getDimensions())
      )
    end
  end

  return quads
end
