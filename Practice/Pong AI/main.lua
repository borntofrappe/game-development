Class = require('res/class')

require 'Paddle'
require 'Puck'

WINDOW = {
    width = 360,
    height = 460,
    options = {
        fullscreen = false,
    },
    padding = 8
}

PADDLE = {
    width = 60,
    height = 10,
    scope = {
        min = WINDOW.height / 3,
        max = WINDOW.height
    },
    speed = 200
}

PUCK = {
    size = 10,
    speed = {
        min = 50,
        max = 150
    }
}

function love.load()
    love.window.setMode(WINDOW.width, WINDOW.height, WINDOW.options)
    love.window.setTitle('pong-ai')

    love.graphics.setLineWidth(2)

    gameState = 'waiting' -- waiting - playing

    fonts = {
        normal = love.graphics.newFont('res/font.ttf', 16),
        large = love.graphics.newFont('res/font.ttf', 28),
    }
    love.graphics.setFont(fonts.normal)

    messages = {
        {
            text = 'Support',
            center = {
                x = WINDOW.width / 2,
                y = WINDOW.height / 4
            }
        },
        {
            text = 'Support',
            center = {
                x = WINDOW.width / 2,
                y = WINDOW.height * 3 / 4
            }
        }
    }

    for i, message in ipairs(messages) do
        message.text = message.text:upper()
        message.width = fonts.large:getWidth(message.text) * 1.1
        message.x = message.center.x - message.width / 2
        message.height = fonts.large:getHeight()
        message.y = message.center.y - message.height / 2
    end

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

        if puck.x <= 0 then 
            puck.x = 0
            puck.dx = math.abs(puck.dx)

            ai1.looksAhead = true
            ai2.looksAhead = true
        elseif puck.x >= WINDOW.width - puck.width then 
            puck.x = WINDOW.width - puck.width
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
            puck.y = ai1.y + ai1.height
            puck.dy = math.abs(puck.dy) * 1.2
        elseif puck:collides(ai2) then
            puck.y = ai2.y - puck.height
            puck.dy = math.abs(puck.dy) * -1 * 1.2
        end
    end
end

function love.draw()
    love.graphics.clear(1, 1, 1)

    if gameState == 'waiting' then 
        love.graphics.setColor(0.02, 0.02, 0.01)
        love.graphics.setFont(fonts.normal)
        love.graphics.print('Points: ' .. ai1.points, 8, WINDOW.height / 2 - 16)
        love.graphics.printf('Points: ' .. ai2.points, -8, WINDOW.height / 2, WINDOW.width, 'right')

        love.graphics.setColor(0.02, 0.02, 0.01)
        love.graphics.setFont(fonts.large)
        if player.side == 1 then 
            love.graphics.setColor(0.02, 0.02, 0.01)
            love.graphics.rectangle('fill', messages[1].x, messages[1].y, messages[1].width, messages[1].height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(messages[1].text, messages[1].x, messages[1].y + 2, messages[1].width, 'center')
        else
            love.graphics.setColor(0.02, 0.02, 0.01)
            love.graphics.rectangle('fill', messages[2].x, messages[2].y, messages[2].width, messages[2].height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(messages[2].text, messages[2].x, messages[2].y + 2, messages[2].width, 'center')
        end
    end

    love.graphics.setColor(0.02, 0.02, 0.01)
    puck:render()
    ai1:render()
    ai2:render()
end