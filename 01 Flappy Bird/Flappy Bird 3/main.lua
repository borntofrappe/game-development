push = require 'res/lib/push'
Class = require 'res/lib/class'

require 'Bird'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

OPTIONS = {
    fullscreen = false,
    resizable = true,
    vsync = true
}

BACKGROUND_OFFSET_SPEED = 10
GROUND_OFFSET_SPEED = 30
BACKGROUND_LOOPING_POINT = 512
GROUND_LOOPING_POINT = 512

local background = love.graphics.newImage('res/graphics/background.png')
local ground = love.graphics.newImage('res/graphics/ground.png')

local bird = Bird()

function love.load()
    love.window.setTitle('Flappy Bird')

    font = love.graphics.newFont('res/fonts/font.ttf', 32)
    love.graphics.setFont(font)

    background_offset = 0
    ground_offset = 0

    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        bird.y = bird.y - 30
        bird.dy = 0        
    end
end

function love.update(dt)
    background_offset = (background_offset + BACKGROUND_OFFSET_SPEED * dt) % BACKGROUND_LOOPING_POINT
    ground_offset = (ground_offset + GROUND_OFFSET_SPEED * dt) % GROUND_LOOPING_POINT

    if bird.y < VIRTUAL_HEIGHT - bird.height - 16 then
        bird:update(dt)
    end
end

function love.draw()
    push:start()

    love.graphics.draw(background, -background_offset, 0)
    love.graphics.draw(ground, -ground_offset, VIRTUAL_HEIGHT - 16)

    bird:render()

    love.graphics.printf(
        'Flappy Bird',
        0,
        VIRTUAL_HEIGHT / 8 - 16,
        VIRTUAL_WIDTH,
        'center'
    )

    push:finish()
end