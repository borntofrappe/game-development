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

    font = love.graphics.newFont('res/Righteous-Regular.ttf', 24)
    love.graphics.setFont(font)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    player1 = Paddle:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 30, true)
    player2 = Paddle:init(WINDOW_WIDTH / 2, 0, 30, false)

    ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
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


    if ball:collides(player1) then
        ball:bounce(player1)
        
    elseif ball:collides(player2) then
        ball:bounce(player2)
    end

    if ball.y < 0 then
        player1:score()
        ball:reset()
    elseif ball.y > WINDOW_HEIGHT then
        player2:score()
        ball:reset()
    end

    player1:update(dt)
    player2:update(dt)

    ball:update(dt)
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

end