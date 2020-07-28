require 'Android'
require 'Lollipop'

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 550
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true,
}


local background = love.graphics.newImage('res/background.png')

BACKGROUND_WIDTH = background:getWidth()
BUILDINGS_1_OFFSET = 0
BUILDINGS_1_SPEED = 30
local buildings_1 = love.graphics.newImage('res/buildings-1.png')
BUILDINGS_2_OFFSET = 0
BUILDINGS_2_SPEED = 15
local buildings_2 = love.graphics.newImage('res/buildings-2.png')
BUILDINGS_3_OFFSET = 0
BUILDINGS_3_SPEED = 5
local buildings_3 = love.graphics.newImage('res/buildings-3.png')

local moon = love.graphics.newImage('res/moon.png')
local lollipops = {}
COUNTDOWN_TIME = 1
INTERVAL_TIME = 4

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Bouncing Android')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    android = Android:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2 + 20)

    table.insert(lollipops, Lollipop:init())
    interval = INTERVAL_TIME
    timer = 0
    love.mouse.waspressed = nil
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

    timer = timer + dt
    if timer > COUNTDOWN_TIME then
        timer = timer % COUNTDOWN_TIME
        interval = interval - 1

        if interval == 0 then
            interval = INTERVAL_TIME
            table.insert(lollipops, Lollipop:init())
        end
    end

    for k, lollopop in pairs(lollipops) do
        lollopop:update(dt)

        if lollopop.remove then
            table.remove(lollipops, k)
        end
    end
    android:update(dt)
    love.mouse.waspressed = nil
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(buildings_3, -BUILDINGS_3_OFFSET, 20)
    love.graphics.draw(buildings_2, -BUILDINGS_2_OFFSET, 20)
    love.graphics.draw(buildings_1, -BUILDINGS_1_OFFSET, 20)

    love.graphics.draw(moon, 50, 325)

    for k, lollopop in pairs(lollipops) do
        lollopop:render()
    end
    android:render()
end