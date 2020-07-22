push = require 'res/lib/push'
Class = require 'res/lib/class'

require 'Bird'
require 'Pipe'

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
local pipes = {}

local timer = 0
local interval = 3

function love.load()
    love.window.setTitle('Flappy Bird')
    math.randomseed(os.time())

    font = love.graphics.newFont('res/fonts/font.ttf', 32)
    love.graphics.setFont(font)

    background_offset = 0
    ground_offset = 0

    love.keyboard.key_pressed = {}

    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.keypressed(key)
    love.keyboard.key_pressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end

    if key == 'p' then
        table.insert(pipes, Pipe())
    end
end

function love.keyboard.waspressed(key)
    return love.keyboard.key_pressed[key]
end

function love.update(dt)
    background_offset = (background_offset + BACKGROUND_OFFSET_SPEED * dt) % BACKGROUND_LOOPING_POINT
    ground_offset = (ground_offset + GROUND_OFFSET_SPEED * dt) % GROUND_LOOPING_POINT

    timer = timer + dt
    if timer > interval then
        timer = timer % interval
        table.insert(pipes, Pipe())
    end

    if bird.y < VIRTUAL_HEIGHT - bird.height - 16 then
        bird:update(dt)
    end

    for k, pipe in pairs(pipes) do
        pipe:update(dt)

        if pipe.x < 0 - pipe.width then
            table.remove(pipes, k)
        end
    end

    love.keyboard.key_pressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -background_offset, 0)
    
    for k, pipe in pairs(pipes) do
        pipe:render()    
    end
    
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