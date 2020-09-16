Class = require "res/lib/class"

require "src/Android"
require "src/Lollipop"
require "src/LollipopPair"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/TitleScreenState"
require "src/states/PlayState"
require "src/states/ScoreState"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 550
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true
}

local background = love.graphics.newImage("res/graphics/background.png")

function love.load()
    love.window.setTitle("Bouncing Android")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    font = love.graphics.newFont("res/fonts/font.ttf", 20)
    love.graphics.setFont(font)

    love.mouse.waspressed = false

    gStateMachine =
        StateMachine(
        {
            ["title"] = function()
                return TitleScreenState()
            end,
            ["play"] = function()
                return PlayState()
            end,
            ["score"] = function()
                return ScoreState()
            end
        }
    )

    gStateMachine:change("title")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed()
    love.mouse.waspressed = true
end

function love.update(dt)
    gStateMachine:update(dt)

    love.mouse.waspressed = false
end

function love.draw()
    love.graphics.draw(background, 0, 0)

    gStateMachine:render()
end
