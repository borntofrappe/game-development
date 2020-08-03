require 'Android'
require 'Lollipop'
require 'LollipopPair'

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

lollipop_pairs = {}

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Bouncing Android')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    android = Android:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2 + 20)

    lollipop_images = {
        love.graphics.newImage('res/lollipop-1.png'),
        love.graphics.newImage('res/lollipop-2.png'),
        love.graphics.newImage('res/lollipop-3.png'),
        love.graphics.newImage('res/lollipop-4.png')
    }

    table.insert(lollipop_pairs, LollipopPair:init(lollipop_images[math.random(#lollipop_images)]))
    timer = 0
    interval = 4
    love.mouse.waspressed = false
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
    if timer > 1 then
        timer = timer % 1
        interval = interval - 1

        if interval == 0 then
            interval = math.random(3, 5)
            table.insert(lollipop_pairs, LollipopPair:init(lollipop_images[math.random(#lollipop_images)]))
        end
    end

    for k, lollipop_pair in pairs(lollipop_pairs) do
        lollipop_pair:update(dt)

        if lollipop_pair.remove then
            table.remove(lollipop_pairs, k)
        end
    end
    android:update(dt)
    love.mouse.waspressed = false
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(buildings_3, -BUILDINGS_3_OFFSET, 20)
    love.graphics.draw(buildings_2, -BUILDINGS_2_OFFSET, 20)
    love.graphics.draw(buildings_1, -BUILDINGS_1_OFFSET, 20)

    love.graphics.draw(moon, 50, 325)

    for k, lollipop_pair in pairs(lollipop_pairs) do
        lollipop_pair:render()
    end
    android:render()
end