require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 380
WINDOW_HEIGHT = 580
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true,
}

PADDLE_SPEED = 300
COUNTDOWN_TIME = 0.5

function love.load()
    math.randomseed(os.time())

    gameState = 'waiting'
    countdown = 3
    timer = 0

    love.window.setTitle('2 Player Pong – state')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)
    player1 = Paddle:init(WINDOW_WIDTH / 2, 0, 30)
    player2 = Paddle:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 30)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if gameState == 'waiting' then
        if y < WINDOW_HEIGHT / 2 and not player1.isReady then
            player1.isReady = true
            if player2.isReady then
                gameState = 'serving'
            end
        end
        if y > WINDOW_HEIGHT / 2 and not player2.isReady then
            player2.isReady = true
            if player1.isReady then
                gameState = 'serving'
            end
        end

    elseif gameState == 'playing' then
        if y < WINDOW_HEIGHT / 2 then
            if x > WINDOW_WIDTH / 2 then
                player1.dx = PADDLE_SPEED
            else
                player1.dx = -PADDLE_SPEED
            end
        end

        if y > WINDOW_HEIGHT / 2 then
            if x > WINDOW_WIDTH / 2 then
                player2.dx = PADDLE_SPEED
            else
                player2.dx = -PADDLE_SPEED
            end
        end
    end
end

function love.mousereleased()
    player1.dx = 0
    player2.dx = 0
end

function love.update(dt)
    if gameState == 'serving' then
        timer = timer + dt
        if timer > COUNTDOWN_TIME then
            timer = timer % COUNTDOWN_TIME
            countdown = countdown - 1
        end

        if countdown == 0 then
            gameState = 'playing'
            timer = 0
            countdown = 3
        end
    end
    if gameState == 'playing' then
        ball:update(dt)
        player1:update(dt)
        player2:update(dt)

        if ball:collides(player1) and ball.dy < 0 then
            ball.dy = ball.dy * -1.1
            if ball.cx > player1.cx then
                ball.dx = math.random(50, 150)
            else
                ball.dx = math.random(50, 150) * -1
            end
        elseif ball:collides(player2) and ball.dy > 0 then
            ball.dy = ball.dy * -1.1
            if ball.cx > player2.cx then
                ball.dx = math.random(50, 150)
            else
                ball.dx = math.random(50, 150) * -1
            end
        end

        if ball.cy < ball.r or ball.cy > WINDOW_HEIGHT - ball.r then
            gameState = 'waiting'
            ball:reset()
            player1:reset()
            player2:reset()
        end
    
    end
end


function love.draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setColor(1, 1, 1, 1)

    -- environment
    love.graphics.setLineWidth(8)
    love.graphics.line(0, 0, WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0, WINDOW_HEIGHT, 0, 0) 
    love.graphics.setLineWidth(2)
    love.graphics.line(0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, WINDOW_HEIGHT / 2) 
    love.graphics.setColor(1, 1, 1, 0.15)
    love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('line', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42)

    
    
    -- ball
    ball:render()

    -- paddles
    player1:render()
    player2:render()


    if gameState == 'waiting' then
        love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4)
        love.graphics.rotate(math.pi)
        if player1.isReady then 
            love.graphics.printf("Ready", -WINDOW_WIDTH / 2, 0, WINDOW_WIDTH, 'center')
        else
            love.graphics.printf("Press to start", -WINDOW_WIDTH / 2, 0, WINDOW_WIDTH, 'center')
        end

        love.graphics.rotate(math.pi)
        love.graphics.translate(0, WINDOW_HEIGHT / 2)
        if player2.isReady then 
            love.graphics.printf("Ready", -WINDOW_WIDTH / 2, 0, WINDOW_WIDTH, 'center')
        else
            love.graphics.printf("Press to start", -WINDOW_WIDTH / 2, 0, WINDOW_WIDTH, 'center')
        end

    elseif gameState == 'serving' then
        love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4)
        love.graphics.rotate(math.pi)
        love.graphics.printf("Ready", -WINDOW_WIDTH / 2, 0, WINDOW_WIDTH, 'center')
        love.graphics.printf(countdown, -WINDOW_WIDTH / 2, 20, WINDOW_WIDTH, 'center')

        love.graphics.rotate(math.pi)
        love.graphics.translate(0, WINDOW_HEIGHT / 2)
        love.graphics.printf("Ready", -WINDOW_WIDTH / 2, 0, WINDOW_WIDTH, 'center')
        love.graphics.printf(countdown, -WINDOW_WIDTH / 2, 20, WINDOW_WIDTH, 'center')
    end


end