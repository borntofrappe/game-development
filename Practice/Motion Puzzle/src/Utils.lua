function GenerateQuadsTiles(atlas)
    local quads = {}
    local x = 512
    local y = 0
    for i = 1, 2 do
        table.insert(
            quads,
            love.graphics.newQuad(x + (i - 1) * TILE_SIZE, y, TILE_SIZE, TILE_SIZE, atlas:getDimensions())
        )
    end

    return quads
end

function GenerateQuadsLevels(atlas)
    local quads = {}
    local x = 0
    local y = 0
    local framesLevels = {2, 3}

    for i, framesLevel in ipairs(framesLevels) do
        quads[i] = {}

        x = 0
        for frameLevel = 1, framesLevel do
            table.insert(quads[i], love.graphics.newQuad(x, y, PUZZLE_SIZE, PUZZLE_SIZE, atlas:getDimensions()))

            x = x + PUZZLE_SIZE
        end
        y = y + PUZZLE_SIZE
    end

    return quads
end
