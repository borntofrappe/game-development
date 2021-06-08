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

local background = love.graphics.newImage("res/graphics/background.png")
local ground = love.graphics.newImage("res/graphics/ground.png")

function love.load()
    love.window.setTitle("Flappy Bird")

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

function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    push:finish()
end
