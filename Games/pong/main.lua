require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 425
WINDOW_HEIGHT = 550
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true,
}

function love.load()
    love.window.setTitle('Pong')
    font = love.graphics.newFont('res/Righteous-Regular.ttf', 24)
    love.graphics.setFont(font)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    player1 = Paddle:init(WINDOW_WIDTH / 2, 0, 30, false)
    player2 = Paddle:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 30, true)

    ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end



function love.draw()
    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1, 0.05)
    love.graphics.arc('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42, 0, math.pi) 
    love.graphics.setColor(1, 1, 1, 0.05)
    love.graphics.arc('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42, math.pi, math.pi * 2) 
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.line(0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, WINDOW_HEIGHT / 2) 
    love.graphics.circle('line', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42) 
    
    --score at either side
    love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    love.graphics.rotate(math.pi)
    love.graphics.printf(0, 0, 5, WINDOW_WIDTH / 2 - 8, 'right')
    love.graphics.rotate(math.pi)
    love.graphics.printf(0, 0, 5, WINDOW_WIDTH / 2 - 8, 'right')
    love.graphics.translate(-WINDOW_WIDTH / 2, -WINDOW_HEIGHT / 2)
    
    -- ball
    ball:render()

    -- paddles
    player1:render()
    player2:render()

end