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

function love.load()
    love.window.setTitle('Bouncing Android')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    BUILDINGS_1_OFFSET = (BUILDINGS_1_OFFSET + BUILDINGS_1_SPEED * dt) % BACKGROUND_WIDTH
    BUILDINGS_2_OFFSET = (BUILDINGS_2_OFFSET + BUILDINGS_2_SPEED * dt) % BACKGROUND_WIDTH
    BUILDINGS_3_OFFSET = (BUILDINGS_3_OFFSET + BUILDINGS_3_SPEED * dt) % BACKGROUND_WIDTH
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(buildings_3, -BUILDINGS_3_OFFSET, 20)
    love.graphics.draw(buildings_2, -BUILDINGS_2_OFFSET, 20)
    love.graphics.draw(buildings_1, -BUILDINGS_1_OFFSET, 20)

    love.graphics.draw(moon, 50, 300)
end