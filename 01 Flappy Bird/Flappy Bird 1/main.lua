push = require "res/lib/push"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

OPTIONS = {
    fullscreen = false,
    resizable = true,
    vsync = true
}

BACKGROUND_OFFSET_SPEED = 30
GROUND_OFFSET_SPEED = 60
BACKGROUND_LOOPING_POINT = 512
GROUND_LOOPING_POINT = 512

local background = love.graphics.newImage("res/graphics/background.png")
local ground = love.graphics.newImage("res/graphics/ground.png")

function love.load()
    love.window.setTitle("Flappy Bird")

    background_offset = 0
    ground_offset = 0

    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
    background_offset = (background_offset + BACKGROUND_OFFSET_SPEED * dt) % BACKGROUND_LOOPING_POINT
    ground_offset = (ground_offset + GROUND_OFFSET_SPEED * dt) % GROUND_LOOPING_POINT
end

function love.draw()
    push:start()

    love.graphics.draw(background, -background_offset, 0)
    love.graphics.draw(ground, -ground_offset, VIRTUAL_HEIGHT - 16)

    push:finish()
end
