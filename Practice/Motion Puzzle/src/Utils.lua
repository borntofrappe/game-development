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
