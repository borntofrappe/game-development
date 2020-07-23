push = require 'res/lib/push'
Class = require 'res/lib/class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'

require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'

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

function love.load()
    love.window.setTitle('Flappy Bird')
    math.randomseed(os.time())

    font_small = love.graphics.newFont('res/fonts/font.ttf', 8)
    font_normal = love.graphics.newFont('res/fonts/font.ttf', 16)
    font_big = love.graphics.newFont('res/fonts/font.ttf', 48)

    love.graphics.setFont(font_normal)

    background_offset = 0
    ground_offset = 0

    love.keyboard.key_pressed = {}
    love.mouse.coor = {
        ['x'] = 0,
        ['y'] = 0
    }

    gStateMachine = StateMachine({
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    })

    gStateMachine:change('title')

    sounds = {
        ['countdown'] = love.audio.newSource('res/sounds/countdown.wav', 'static'),
        ['hit'] = love.audio.newSource('res/sounds/hit.wav', 'static'),
        ['jump'] = love.audio.newSource('res/sounds/jump.wav', 'static'),
        ['lose'] = love.audio.newSource('res/sounds/lose.wav', 'static'),
        ['score'] = love.audio.newSource('res/sounds/score.wav', 'static'),
        ['soundtrack'] = love.audio.newSource('res/sounds/soundtrack.wav', 'static')
    }

    sounds['soundtrack']:setLooping(true)
    sounds['soundtrack']:play()

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
end

function love.keyboard.waspressed(key)
    return love.keyboard.key_pressed[key]
end

function love.mousepressed(x, y)
    love.mouse.coor['x'], love.mouse.coor['y'] = push:toGame(x, y)
end

function love.update(dt)
    background_offset = (background_offset + BACKGROUND_OFFSET_SPEED * dt) % BACKGROUND_LOOPING_POINT
    ground_offset = (ground_offset + GROUND_OFFSET_SPEED * dt) % GROUND_LOOPING_POINT
    
    
    gStateMachine:update(dt)
    
    love.keyboard.key_pressed = {}
    love.mouse.coor['x'], love.mouse.coor['y'] = 0, 0
end

function love.draw()
    push:start()

    love.graphics.draw(background, -background_offset, 0)
    
    gStateMachine:render()
    
    love.graphics.draw(ground, -ground_offset, VIRTUAL_HEIGHT - 16)
    push:finish()
end