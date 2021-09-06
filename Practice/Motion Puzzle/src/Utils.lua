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
    local framesLevels = {2, 3, 3, 3}

    for i, framesLevel in ipairs(framesLevels) do
        quads[i] = {}
        x = 0
        for frameLevel = 1, framesLevel do
            quads[i][frameLevel] = {}
            for column = 1, PUZZLE_DIMENSIONS do
                quads[i][frameLevel][column] = {}
                for row = 1, PUZZLE_DIMENSIONS do
                    quads[i][frameLevel][column][row] =
                        love.graphics.newQuad(
                        x + (column - 1) * PIECE_SIZE,
                        y + (row - 1) * PIECE_SIZE,
                        PIECE_SIZE,
                        PIECE_SIZE,
                        atlas:getDimensions()
                    )
                end
            end

            x = x + PUZZLE_SIZE
        end
        y = y + PUZZLE_SIZE
    end

    return quads
end

function GenerateQuadsHighlight(atlas)
    local quads = {}
    local x = 512
    local y = 4

    for i = 1, 2 do
        table.insert(
            quads,
            love.graphics.newQuad(x + (i - 1) * PIECE_SIZE, y, PIECE_SIZE, PIECE_SIZE, atlas:getDimensions())
        )
    end

    return quads
end

function GenerateQuadsPointer(atlas)
    local quads = {}
    local x = 512
    local y = 68

    for i = 1, 2 do
        table.insert(
            quads,
            love.graphics.newQuad(x + (i - 1) * PIECE_SIZE, y, PIECE_SIZE, PIECE_SIZE, atlas:getDimensions())
        )
    end

    return quads
end

function GenerateQuadsSelection(atlas)
    local quads = {}
    local x = 512
    local y = 132

    for i = 1, 2 do
        table.insert(
            quads,
            love.graphics.newQuad(x + (i - 1) * PIECE_SIZE, y, PIECE_SIZE, PIECE_SIZE, atlas:getDimensions())
        )
    end

    return quads
end

function GenerateKey(column, row)
    return "c" .. column .. "r" .. row
end
