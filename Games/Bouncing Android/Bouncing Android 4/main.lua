Class = require 'res/lib/class'

require 'Android'
require 'Lollipop'

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 550
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true,
}


local background = love.graphics.newImage('res/graphics/background.png')

BACKGROUND_WIDTH = background:getWidth()
BUILDINGS_1_OFFSET = 0
BUILDINGS_1_SPEED = 30
local buildings_1 = love.graphics.newImage('res/graphics/buildings-1.png')
BUILDINGS_2_OFFSET = 0
BUILDINGS_2_SPEED = 15
local buildings_2 = love.graphics.newImage('res/graphics/buildings-2.png')
BUILDINGS_3_OFFSET = 0
BUILDINGS_3_SPEED = 5
local buildings_3 = love.graphics.newImage('res/graphics/buildings-3.png')

local moon = love.graphics.newImage('res/graphics/moon.png')

local android = Android(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
local lollipops = {Lollipop()}

function love.load()
    love.window.setTitle('Bouncing Android')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    love.mouse.waspressed = false
    
    timer = 0
    interval = 4
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed()
    love.mouse.waspressed = true
end

function love.update(dt)
    BUILDINGS_1_OFFSET = (BUILDINGS_1_OFFSET + BUILDINGS_1_SPEED * dt) % BACKGROUND_WIDTH
    BUILDINGS_2_OFFSET = (BUILDINGS_2_OFFSET + BUILDINGS_2_SPEED * dt) % BACKGROUND_WIDTH
    BUILDINGS_3_OFFSET = (BUILDINGS_3_OFFSET + BUILDINGS_3_SPEED * dt) % BACKGROUND_WIDTH

    android:update(dt)

    timer = timer + dt
    if timer > 1 then
        timer = timer % 1
        interval = interval - 1

        if interval == 0 then
            interval = 4
            table.insert(lollipops, Lollipop())
        end
    end

    for k, lollipop in pairs(lollipops) do
        lollipop:update(dt)

        if lollipop.remove then
            table.remove(lollipops, k)
        end
    end

    love.mouse.waspressed = false
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(buildings_3, -BUILDINGS_3_OFFSET, 20)
    love.graphics.draw(buildings_2, -BUILDINGS_2_OFFSET, 20)
    love.graphics.draw(buildings_1, -BUILDINGS_1_OFFSET, 20)

    love.graphics.draw(moon, 50, 325)

    for k, lollipop in pairs(lollipops) do
        lollipop:render()
    end

    android:render()
end
