Class = require('res/class')

require 'Paddle'
require 'Puck'

WINDOW = {
    width = 360,
    height = 480,
    options = {
        fullscreen = false,
    },
    padding = 8
}

PADDLE = {
    width = 52,
    height = 8,
    scope = {
        min = WINDOW.height / 3,
        max = WINDOW.height
    },
    speed = 200
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

    player = {
        side = 1,
        guesses = 0,
        correct = 0
    }

    ai1 = Paddle(WINDOW.width / 2 - PADDLE.width / 2, WINDOW.padding)
    ai2 = Paddle(WINDOW.width / 2 - PADDLE.width / 2, WINDOW.height - WINDOW.padding - PADDLE.height)

    puck = Puck(WINDOW.width / 2, WINDOW.height / 2)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'up' or key == 'down' or key == 'tab' then 
        player.side = player.side == 1 and 2 or 1
    end

    if key == 'return' then 
        if gameState == 'waiting' then 
            gameState = 'playing'
            player.guesses = player.guesses + 1

            if player.side == 1 then 
                puck.dy = math.abs(puck.dy) * -1
                ai1.looksAhead = true
            else
                puck.dy = math.abs(puck.dy)
                ai2.looksAhead = true
            end
        end
    end
end

function love.update(dt)
    if gameState == 'playing' then 
        puck:update(dt)
        ai1:update(dt)
        ai2:update(dt)

        if ai1.looksAhead and puck.dy < 0 and math.abs(ai1.y + ai1.height / 2 - puck.y) < ai1.scope then 
            ai1:target(puck)
        end

        if ai2.looksAhead and puck.dy > 0 and math.abs(ai2.y + ai2.height / 2 - puck.y) < ai2.scope then 
            ai2:target(puck)
        end

        if puck.x <= puck.r then 
            puck.x = puck.r
            puck.dx = math.abs(puck.dx)

            ai1.looksAhead = true
            ai2.looksAhead = true
        elseif puck.x >= WINDOW.width - puck.r then 
            puck.x = WINDOW.width - puck.r
            puck.dx = math.abs(puck.dx) * -1

            ai1.looksAhead = true
            ai2.looksAhead = true
        end

        if puck.y <= 0 then
            playerSupport = player.side == 1
            if playerSupport then 
                ai2:score(1)
                player.correct = player.correct + 1
            else
                ai2:score(2)
            end
            puck:reset()
            gameState = 'waiting'
        elseif puck.y >= WINDOW.height then
            playerSupport = player.side == 1
            if playerSupport then 
                ai1:score(1)
                player.correct = player.correct + 1
            else
                ai1:score(2)
            end
            puck:reset()
            gameState = 'waiting'
        end

        if puck:collides(ai1) then
            puck.y = ai1.y + ai1.height + puck.r
            puck.dy = math.abs(puck.dy) * 1.2
        elseif puck:collides(ai2) then
            puck.y = ai2.y - puck.r
            puck.dy = math.abs(puck.dy) * -1 * 1.2
        end
    end
end

function love.draw()
    love.graphics.clear(0.95, 0.95, 0.95)

    if gameState == 'waiting' then 
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.push()
        love.graphics.translate(WINDOW.width, WINDOW.height)
        love.graphics.rotate(math.pi)
        love.graphics.printf('Points: ' .. ai1.points, -8, WINDOW.height / 2 + 4, WINDOW.width, 'right')
        love.graphics.pop()
        love.graphics.printf('Points: ' .. ai2.points, -8, WINDOW.height / 2 + 4, WINDOW.width, 'right')


        if player.side == 1 then 
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