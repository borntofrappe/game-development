TitleScreenState = Class {__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
        gStateMachine:change("countdown")
    end

    if love.mouse.waspressed then
        gStateMachine:change("countdown")
    end
end

function TitleScreenState:render()
    love.graphics.setFont(font_big)
    love.graphics.printf("Flappy Bird", 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(font_normal)
    love.graphics.printf("Press enter to play", 0, VIRTUAL_HEIGHT / 2 + 8, VIRTUAL_WIDTH, "center")
end
