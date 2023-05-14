push = require("res/lib/push")
Class = require("res/lib/class")

require "Player"

require "StateMachine"

require "states/BaseState"
require "states/TitleState"
require "states/PlayState"

gImages = {
    ["background"] = love.graphics.newImage("res/graphics/background.png"),
    ["wall"] = love.graphics.newImage("res/graphics/wall.png"),
    ["strip"] = love.graphics.newImage("res/graphics/strip.png"),
    ["player"] = love.graphics.newImage("res/graphics/player.png")
}

WINDOW_WIDTH = 404
WINDOW_HEIGHT = 408
VIRTUAL_WIDTH = 101
VIRTUAL_HEIGHT = 102
OPTIONS = {
    fullscreen = false,
    resizable = true
}

local SCROLL_SPEED = 50
local SCROLL_THRESHOLD = VIRTUAL_HEIGHT
local scroll_offset = 0

function love.load()
    love.window.setTitle("Side Operation")
    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

    gFont = love.graphics.newFont("res/fonts/font.ttf", 8)
    love.graphics.setFont(gFont)

    love.keyboard.key_pressed = {}

    gStateMachine =
        StateMachine(
        {
            ["title"] = function()
                return TitleState()
            end,
            ["play"] = function()
                return PlayState()
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

function love.keyboard.was_pressed(key)
    return love.keyboard.key_pressed[key]
end

function love.update(dt)
    scroll_offset = (scroll_offset + SCROLL_SPEED * dt) % SCROLL_THRESHOLD

    gStateMachine:update(dt)

    love.keyboard.key_pressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(gImages["background"], 0, -scroll_offset)
    love.graphics.draw(gImages["background"], 0, VIRTUAL_HEIGHT - scroll_offset)
    love.graphics.draw(gImages["wall"], 0, 0)
    love.graphics.draw(gImages["wall"], VIRTUAL_WIDTH, 0, 0, -1, 1)

    gStateMachine:render()

    push:finish()
end
