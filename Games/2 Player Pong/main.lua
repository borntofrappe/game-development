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
COUNTDOWN_TIME = 0.5

function love.load()
    love.window.setTitle('Pong')
    
    math.randomseed(os.time())

    scoreFont = love.graphics.newFont('res/Righteous-Regular.ttf', 24)
    titleFont = love.graphics.newFont('res/Righteous-Regular.ttf', 32)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    player1 = Paddle:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 28, true)
    player2 = Paddle:init(WINDOW_WIDTH / 2, 0, 28, false)

    players = { 
        {
            player = player1,
            right = "right",
            left = "left"
        }, 
        {
            player = player2,
            right = "d",
            left = "a"
        }
    }

    ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)

    gameState = 'waiting'

    timer = 0
    count = 3

    sounds = {
        ['bounce'] = love.audio.newSource('res/sounds/bounce.wav', 'static'),
        ['point'] = love.audio.newSource('res/sounds/point.wav', 'static'),
        ['countdown'] = love.audio.newSource('res/sounds/countdown.wav', 'static'),
    }
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if gameState == 'waiting' then
            sounds["countdown"]:play()
            gameState = 'serving'
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
    if gameState == 'serving' then
        timer = timer + dt
        if timer > COUNTDOWN_TIME then
            sounds["countdown"]:play()
            timer = timer % COUNTDOWN_TIME
            count = count - 1
        end
        if count == 0 then
            gameState = 'playing'
            timer = 0
            count = 3
        end
    end
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
            if ball:collides(player.player) then
                ball:bounce(player.player)
                sounds["bounce"]:play()
            end
 
            if i == 1 then
                if ball.y < 0 then
                    sounds["point"]:play()
                    player.player:score()
                    if player.player.points >= 10 then
                        player.player.hasWon = true
                        gameState = 'gameover'
                    else
                        gameState = 'waiting'
                        ball:reset('bottom')    
                    end
                end

            else
                if ball.y > WINDOW_HEIGHT then
                    sounds["point"]:play()
                    player.player:score()
                    if player.player.points >= 10 then
                        player.player.hasWon = true
                        gameState = 'gameover'
                    else
                        gameState = 'waiting'
                        ball:reset('top')    
                    end
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

    ball:render()

    for i, player in ipairs(players) do
        player.player:render()
    end

    love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    for i, player in ipairs(players) do
        love.graphics.setFont(scoreFont)
        love.graphics.printf(player.player.points, 0, 5, WINDOW_WIDTH / 2 - 8, 'right')

        if gameState == 'waiting' then
            love.graphics.setFont(titleFont)
            title = 'Press enter'
            love.graphics.printf(title:upper(), -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
        elseif gameState == 'serving' then
            love.graphics.setFont(titleFont)
            love.graphics.printf(count, -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
        elseif gameState == 'gameover' then
            love.graphics.setFont(titleFont)
            title = player.player.hasWon and 'Congrats!' or 'Too bad..'
            love.graphics.printf(title:upper(), -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
        end
        love.graphics.rotate(math.pi)
    end
end