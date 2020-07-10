require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 425
WINDOW_HEIGHT = 550
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true,
}

PADDLE_SPEED = 250

function love.load()
    love.window.setTitle('Pong')
    
    math.randomseed(os.time())

    appFont = love.graphics.newFont('res/Righteous-Regular.ttf', 14)
    scoreFont = love.graphics.newFont('res/Righteous-Regular.ttf', 24)
    titleFont = love.graphics.newFont('res/Righteous-Regular.ttf', 32)
    love.graphics.setFont(appFont)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    player1 = Paddle:init(0, WINDOW_HEIGHT / 2, 30)
    player2 = Paddle:init(0, WINDOW_HEIGHT / 2, 30)

    players = {}
    players[1] = {
        player = player1,
        right = "right",
        left = "left"
    }
    players[2] = {
        player = player2,
        right = "a",
        left = "d"
    }

    ball = Ball:init(0, 0, 8)

    gameState = 'waiting'
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if gameState == 'waiting' then
            gameState = 'playing'
        elseif gameState == 'gameover' then
            gameState = 'waiting'
            ball:reset()
            for i, player in ipairs(players) do
                player.player:score(0)
                player.player.hasWon = false
            end
        elseif gameState == 'playing' then
            gameState = 'waiting'
        end
    end
end

function love.update(dt)
    for i, player in ipairs(players) do
        if love.keyboard.isDown(player.right) then
            player.player.dx = PADDLE_SPEED
        elseif love.keyboard.isDown(player.left) then
            player.player.dx = -PADDLE_SPEED
        else
            player.player.dx = 0
        end

        player.player:update(dt)
    end

    if gameState == 'playing' then
        ball:update(dt)

        for i, player in ipairs(players) do
            if ball:collides(player.player, i == 1) then
                ball:bounce(player.player)
            end
 
            if i == 1 then
                if ball.y < -WINDOW_HEIGHT / 2 then
                    player.player:score()
                    if player.player.points >= 10 then
                        player.player.hasWon = true
                        gameState = 'gameover'
                    else
                        gameState = 'waiting'
                        ball:reset(i)    
                    end
                    break
                end

            else
                if ball.y > WINDOW_HEIGHT / 2 then
                    player.player:score()
                    if player.player.points >= 10 then
                        player.player.hasWon = true
                        gameState = 'gameover'
                    else
                        gameState = 'waiting'
                        ball:reset(i)    
                    end
                    break
                end

            end

        end    
    end
end

function love.draw()
    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.line(0, 0, WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0, WINDOW_HEIGHT, 0, 0)
    love.graphics.line(0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, WINDOW_HEIGHT / 2) 
    love.graphics.setColor(1, 1, 1, 0.1)
    love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42) 
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('line', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42) 

    if gameState == 'waiting' then
        a1 = ball.dy > 0 and 0 or math.pi
        a2 = a1 + math.pi
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.arc('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42, a1, a2) 
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

    love.graphics.setFont(scoreFont)
    for i, player in ipairs(players) do
        love.graphics.printf(player.player.points, 0, 5, WINDOW_WIDTH / 2 - 8, 'right')
        player.player:render()
        love.graphics.rotate(math.pi)
    end

    -- ball
    ball:render()

    if gameState == 'waiting' then
        love.graphics.setFont(appFont)
        instruction = 'Press enter'
        for _, player in ipairs(players) do
            for i = 1, #instruction do
                letter = instruction:sub(i, i):upper()
                love.graphics.printf(letter, WINDOW_WIDTH / 2 - 24, WINDOW_HEIGHT / 2 - 24 - 14 * #instruction + 14 * i, 14, 'center')
            end
            love.graphics.rotate(math.pi)
        end

    end

    if gameState == 'gameover' then
        love.graphics.setFont(titleFont)

        winningSide = player1.points > player2.points and 1 or 2
        for i, player in ipairs(players) do
            title = player.player.hasWon and 'Congrats' or 'Too bad..'
            love.graphics.printf(title:upper(), -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
            love.graphics.rotate(math.pi)
        end
    end

end