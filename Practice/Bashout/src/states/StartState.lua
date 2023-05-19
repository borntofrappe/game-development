StartState = Class {__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.waspressed("escape") then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures["spritesheet"], gQuads["paddle"], 0, 0)
    love.graphics.draw(gTextures["spritesheet"], gQuads["ball"], 0, PADDLE_HEIGHT)
    love.graphics.draw(gTextures["spritesheet"], gQuads["score"], 0, PADDLE_HEIGHT + BALL_HEIGHT)
    love.graphics.draw(gTextures["spritesheet"], gQuads["arrow"], 0, PADDLE_HEIGHT + BALL_HEIGHT + SCORE_HEIGHT)
    for i = 1, 4 do
        love.graphics.draw(
            gTextures["spritesheet"],
            gQuads["boxes"][i],
            BOX_WIDTH * (i - 1),
            PADDLE_HEIGHT + BALL_HEIGHT + SCORE_HEIGHT + ARROW_HEIGHT
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts["large"])
    love.graphics.printf("Bashout", 0, VIRTUAL_HEIGHT / 2 - gFonts["large"]:getHeight() / 2, VIRTUAL_WIDTH, "center")
end
