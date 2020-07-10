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

    player1 = Paddle:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 30, true)
    player2 = Paddle:init(WINDOW_WIDTH / 2, 0, 30, false)

    ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)


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
            player1:score(0)
            player2:score(0)
        elseif gameState == 'playing' then
            gameState = 'waiting'
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown('right') then
        player1.dx = PADDLE_SPEED
    elseif love.keyboard.isDown('left') then
        player1.dx = -PADDLE_SPEED
    else
        player1.dx = 0
    end

    if love.keyboard.isDown('d') then
        player2.dx = PADDLE_SPEED
    elseif love.keyboard.isDown('a') then
        player2.dx = -PADDLE_SPEED
    else
        player2.dx = 0
    end

    player1:update(dt)
    player2:update(dt)

    if gameState == 'playing' then
        if ball:collides(player1) then
            ball:bounce(player1)
            
        elseif ball:collides(player2) then
            ball:bounce(player2)
        end
    
        if ball.y < 0 then
            player1:score()
            if player1.points >= 2 then 
                gameState = 'gameover'
            else
                gameState = 'waiting'
                ball:reset()
            end
        elseif ball.y > WINDOW_HEIGHT then
            player2:score()
            if player2.points >= 2 then 
                gameState = 'gameover'
            else
                gameState = 'waiting'
                ball:reset()
            end
        end
    
        ball:update(dt)
    end
end

function love.draw()
    love.graphics.clear(0, 0, 0, 1)

    -- environment
    love.graphics.setColor(1, 1, 1, 0.05)
    love.graphics.arc('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42, 0, math.pi) 
    love.graphics.setColor(1, 1, 1, 0.05)
    love.graphics.arc('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42, math.pi, math.pi * 2) 
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.line(0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, WINDOW_HEIGHT / 2) 
    love.graphics.circle('line', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42) 
    
    --score
    love.graphics.setFont(scoreFont)
    love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    love.graphics.rotate(math.pi)
    love.graphics.printf(player2.points, 0, 5, WINDOW_WIDTH / 2 - 8, 'right')
    love.graphics.rotate(math.pi)
    love.graphics.printf(player1.points, 0, 5, WINDOW_WIDTH / 2 - 8, 'right')
    love.graphics.translate(-WINDOW_WIDTH / 2, -WINDOW_HEIGHT / 2)
    
    -- ball
    ball:render()

    -- paddles
    player1:render()
    player2:render()


    if gameState == 'waiting' then
        love.graphics.setFont(appFont)
        instruction = 'Press enter'

        love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
        for i = 1, 2 do
            love.graphics.rotate(math.pi)
            for i = 1, #instruction do
                letter = instruction:sub(i, i):upper()
                love.graphics.printf(letter, WINDOW_WIDTH / 2 - 24, WINDOW_HEIGHT / 2 - 24 - 14 * #instruction + 14 * i, 14, 'center')
            end
        end
    end

    if gameState == 'gameover' then
        love.graphics.setFont(titleFont)

        winningSide = player1.points > player2.points and 1 or 2
        love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
        for i = 1, 2 do
            love.graphics.rotate(math.pi)
            title = winningSide == i and 'Too bad..' or 'Congrats!'
            love.graphics.printf(title:upper(), -WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
        end

    end

end