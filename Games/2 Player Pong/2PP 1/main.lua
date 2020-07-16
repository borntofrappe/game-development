require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 380
WINDOW_HEIGHT = 580
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true,
}

function love.load()
    love.window.setTitle('2 Player Pong – drawing')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)
    player1 = Paddle:init(WINDOW_WIDTH / 2, 0, 30, true)
    player2 = Paddle:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 30, false)
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
end