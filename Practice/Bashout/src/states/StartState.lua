StartState = Class {__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.waspressed("escape") then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts["large"])
    love.graphics.printf("Bashout", 0, VIRTUAL_HEIGHT / 2 - gFonts["large"]:getHeight() / 2, VIRTUAL_WIDTH, "center")
end
