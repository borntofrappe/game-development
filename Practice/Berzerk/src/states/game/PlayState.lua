PlayState = BaseState:new()

function PlayState:enter()
end

function PlayState:update(dt)
    if love.keyboard.waspressed("escape") then
        gStateStack:pop()
        gStateStack:push(TitleState:new())
    end
end

function PlayState:render()
    love.graphics.setColor(0.824, 0.824, 0.824)
    love.graphics.setFont(gFonts.normal)
    love.graphics.print("Here you'd play", 8, 8)
end
