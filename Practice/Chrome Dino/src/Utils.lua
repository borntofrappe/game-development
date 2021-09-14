function GenerateQuadsDino(atlas)
    local quads = {}

    for state, dino in pairs(DINO) do
        quads[state] = {}
        for i = 1, dino.frames do
            table.insert(
                quads[state],
                love.graphics.newQuad(
                    dino.x + (i - 1) * dino.width,
                    dino.y,
                    dino.width,
                    dino.height,
                    atlas:getDimensions()
                )
            )
        end
    end

    return quads
end

function GenerateQuadsCacti(atlas)
    local quads = {}

    for i, cactus in pairs(CACTI) do
        table.insert(
            quads,
            love.graphics.newQuad(cactus.x, cactus.y, cactus.width, cactus.height, atlas:getDimensions())
        )
    end

    return quads
end

function GenerateQuadCloud(atlas)
    return love.graphics.newQuad(CLOUD.x, CLOUD.y, CLOUD.width, CLOUD.height, atlas:getDimensions())
end

function GenerateQuadsBird(atlas)
    local quads = {}

    for i, bird in pairs(BIRD) do
        table.insert(quads, love.graphics.newQuad(bird.x, bird.y, bird.width, bird.height, atlas:getDimensions()))
    end

    return quads
end
