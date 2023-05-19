function GenerateQuads(atlas)
    local quads = {}

    quads["paddle"] = love.graphics.newQuad(0, 0, PADDLE_WIDTH, PADDLE_HEIGHT, atlas:getDimensions())
    quads["ball"] = love.graphics.newQuad(0, 17, BALL_WIDTH, BALL_HEIGHT, atlas:getDimensions())
    quads["score"] = love.graphics.newQuad(13, 17, SCORE_WIDTH, SCORE_HEIGHT, atlas:getDimensions())
    quads["arrow"] = love.graphics.newQuad(24, 17, ARROW_WIDTH, ARROW_HEIGHT, atlas:getDimensions())

    quads["boxes"] = {}
    for i = 0, 3 do
        quads["boxes"][#quads["boxes"] + 1] =
            love.graphics.newQuad(17 + i * BOX_WIDTH, 0, BOX_WIDTH, BOX_HEIGHT, atlas:getDimensions())
    end

    return quads
end
