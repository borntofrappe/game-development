Class = require('res/class')

require 'Paddle'
require 'Puck'

WINDOW = {
    width = 350,
    height = 440,
    options = {
        fullscreen = false,
    },
    padding = 8
}

PADDLE = {
    width = 52,
    height = 8
}

PUCK = {
    radius = 8,
    speed = {
        min = 70,
        max = 160
    }
}

function love.load()
    love.window.setMode(WINDOW.width, WINDOW.height, WINDOW.options)
    love.window.setTitle('pong-ai')

    love.graphics.setLineWidth(2)

    gameState = 'waiting' -- waiting - playing
    playerSide = 1

    ai1 = Paddle(WINDOW.width / 2 - PADDLE.width / 2, WINDOW.padding)
    ai2 = Paddle(WINDOW.width / 2 - PADDLE.width / 2, WINDOW.height - WINDOW.padding - PADDLE.height)

    puck = Puck(WINDOW.width / 2, WINDOW.height / 2)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'up' or key == 'down' or key == 'tab' then 
        playerSide = playerSide == 1 and 2 or 1
    end


    if key == 'return' then 
        if gameState == 'waiting' then 
            gameState = 'playing'
        end

    end
end

function love.update(dt)
    if gameState == 'playing' then 
        puck:update(dt)

        if puck.x <= puck.r then 
            puck.x = puck.r
            puck.dx = math.abs(puck.dx)
        elseif puck.x >= WINDOW.width - puck.r * 2 then 
            puck.x = WINDOW.width - puck.r * 2
            puck.dx = math.abs(puck.dx) * -1
        end

        if puck.y <= 0 then 
            puck:reset()
            gameState = 'waiting'
        elseif puck.y >= WINDOW.height then 
            puck:reset()
            gameState = 'waiting'
        end
    end
end

function love.draw()
    love.graphics.clear(0.95, 0.95, 0.95)

    if gameState == 'waiting' then 
        if playerSide == 1 then 
            love.graphics.setColor(0.5, 0.5, 0.5, 0.3)
            love.graphics.rectangle('fill', 0, 0, WINDOW.width, WINDOW.height / 2)
            
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.printf('Pick a side to support', 0, WINDOW.height / 4 - 6, WINDOW.width, 'center')

        else
            love.graphics.setColor(0.5, 0.5, 0.5, 0.3)
            love.graphics.rectangle('fill', 0, WINDOW.height / 2, WINDOW.width, WINDOW.height / 2)
            
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.printf('Pick a side to support', 0, WINDOW.height * 3 / 4 - 6, WINDOW.width, 'center')

        end
    end

    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.line(0, WINDOW.height / 2, WINDOW.width, WINDOW.height / 2)
    love.graphics.rectangle('line', 0, 0, WINDOW.width, WINDOW.height)

    
    puck:render()
    ai1:render()
    ai2:render()
end