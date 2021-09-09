function GenerateQuadsPlayer(atlas)
  local x = 0
  local y = 0

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
    ["walking-down"] = {
      ["frames"] = 3,
      ["x"] = 0,
      ["y"] = 16
    },
    ["walking-right"] = {
      ["frames"] = 3,
      ["x"] = 0,
      ["y"] = 24
    },
    ["walking-up"] = {
      ["frames"] = 3,
      ["x"] = 0,
      ["y"] = 32
    },
    ["walking-left"] = {
      ["frames"] = 3,
      ["x"] = 0,
      ["y"] = 40
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
