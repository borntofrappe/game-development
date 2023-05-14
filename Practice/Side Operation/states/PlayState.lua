PlayState = Class({__includes = BaseState})

function PlayState:init()
end

function PlayState:update(dt)
    if love.keyboard.was_pressed("escape") then
        gStateMachine:change("title")
    end
end

function PlayState:render()
end
