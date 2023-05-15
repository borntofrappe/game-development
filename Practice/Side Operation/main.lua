push = require("res/lib/push")
Class = require("res/lib/class")

require "Player"

require "StateMachine"

require "states/BaseState"
require "states/TitleState"
require "states/CountdownState"
require "states/PlayState"
require "states/PauseState"
require "states/ScoreState"

local images = {
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["wall"] = love.graphics.newImage("res/graphics/wall.png")
}

local WINDOW_WIDTH = 404
local WINDOW_HEIGHT = 408
local OPTIONS = {
    fullscreen = false,
    resizable = true
}

VIRTUAL_WIDTH = 101
VIRTUAL_HEIGHT = 102

local SCROLL_SPEED = 60
local SCROLL_THRESHOLD = VIRTUAL_HEIGHT
local scroll_offset = 0

function love.load()
    love.window.setTitle("Side Operation")
    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

    math.randomseed(os.time())

    gFont = love.graphics.newFont("res/fonts/font.ttf", 8)
    love.graphics.setFont(gFont)

    love.keyboard.key_pressed = {}
    love.mouse.button_pressed = {}

    gStateMachine =
        StateMachine(
        {
            ["title"] = function()
                return TitleState()
            end,
            ["play"] = function()
                return PlayState()
            end,
            ["countdown"] = function()
                return CountdownState()
            end,
            ["pause"] = function()
                return PauseState()
            end,
            ["score"] = function()
                return ScoreState()
            end
        }
    )

    gStateMachine:change("title")
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.keypressed(key)
    love.keyboard.key_pressed[key] = true
end

function love.mousepressed(x, y, button)
    x, y = push:toGame(x, y)
    love.mouse.button_pressed[button] = {
        ["x"] = x,
        ["y"] = y
    }
end

function love.keyboard.was_pressed(key)
    return love.keyboard.key_pressed[key]
end

function love.update(dt)
    scroll_offset = (scroll_offset + SCROLL_SPEED * dt) % SCROLL_THRESHOLD

    gStateMachine:update(dt)

    love.keyboard.key_pressed = {}
    love.mouse.button_pressed = {}
end

function love.draw()
    push:start()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images["background"], 0, -scroll_offset)
    love.graphics.draw(images["background"], 0, VIRTUAL_HEIGHT - scroll_offset)

    gStateMachine:render()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images["wall"], 0, 0)
    love.graphics.draw(images["wall"], VIRTUAL_WIDTH, 0, 0, -1, 1)

    push:finish()
end

function drawOverlay()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
