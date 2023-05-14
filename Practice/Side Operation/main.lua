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

    gFont = love.graphics.newFont("res/fonts/font.ttf", 8)
    love.graphics.setFont(gFont)

    text = string.upper("Side\noperation")
    local width = gFont:getWidth(text) * 1.1
    local height = gFont:getHeight() * 2
    title = {
        ["text"] = text,
        ["width"] = width,
        ["height"] = height,
        ["x"] = VIRTUAL_WIDTH / 2 - width / 2,
        ["y"] = VIRTUAL_HEIGHT / 4
    }
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

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", title["x"], title["y"], title["width"], title["height"])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(title["text"], title["x"], title["y"], title["width"], "center")

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.printf("Press\nto play", 0, VIRTUAL_HEIGHT * 3 / 4 - gFont:getHeight(), VIRTUAL_WIDTH, "center")

    push:finish()
end
