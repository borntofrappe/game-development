function GenerateQuadsDino(atlas)
    local quads = {}

    for k, state in pairs(DINO_STATES) do
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

function GenerateQuadCloud(atlas)
    local x = 39
    local y = 16
    local width = CLOUD_WIDTH
    local height = CLOUD_HEIGHT

    return love.graphics.newQuad(x, y, width, height, atlas:getDimensions())
end
