function GenerateQuadsDino(atlas)
  local states = {
    ["idle"] = {
      ["frames"] = 1,
      ["x"] = 0,
      ["y"] = 0,
      ["width"] = 16,
      ["height"] = 16
    },
    ["run"] = {
      ["frames"] = 2,
      ["x"] = 16,
      ["y"] = 0,
      ["width"] = 16,
      ["height"] = 16
    },
    ["duck"] = {
      ["frames"] = 2,
      ["x"] = 48,
      ["y"] = 5,
      ["width"] = 21,
      ["height"] = 11
    },
    ["gameover"] = {
      ["frames"] = 1,
      ["x"] = 70,
      ["y"] = 0,
      ["width"] = 16,
      ["height"] = 16
    }
  }

  local quads = {}

  for k, state in pairs(states) do
    quads[k] = {}
    for i = 1, state.frames do
      table.insert(
        quads[k],
        love.graphics.newQuad(
          state.x + (i - 1) * state.width,
          state.y,
          state.width,
          state.height,
          atlas:getDimensions()
        )
      )
    end
  end

  return quads
end

function FormatScore(score)
  return string.format("HI %04d  %04d", score.hi, score.current)
end
