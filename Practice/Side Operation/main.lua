push = require("res/lib/push")

gImages = {
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["wall"] = love.graphics.newImage("res/graphics/wall.png"),
    ["strip"] = love.graphics.newImage("res/graphics/strip.png"),
    ["player"] = love.graphics.newImage("res/graphics/player.png")
}

WINDOW_WIDTH = 292
WINDOW_HEIGHT = 408
VIRTUAL_WIDTH = 73
VIRTUAL_HEIGHT = 102
OPTIONS = {
    fullscreen = false,
    resizable = true
}

function love.load()
    love.window.setTitle("Side Operation")
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

    love.graphics.draw(gImages["background"], 0, 0)
    love.graphics.draw(gImages["wall"], 0, 0)
    love.graphics.draw(gImages["wall"], VIRTUAL_WIDTH, 0, 0, -1, 1)
    love.graphics.draw(gImages["strip"], gImages["wall"]:getWidth(), 0)

    love.graphics.draw(gImages["player"], math.floor(VIRTUAL_WIDTH / 2), math.floor(VIRTUAL_HEIGHT / 2))

    push:finish()
end
