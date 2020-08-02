WINDOW_WIDTH = 400
WINDOW_HEIGHT = 550
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true,
}

local background = love.graphics.newImage('res/background.png')

local buildings_1 = love.graphics.newImage('res/buildings-1.png')
local buildings_2 = love.graphics.newImage('res/buildings-2.png')
local buildings_3 = love.graphics.newImage('res/buildings-3.png')

local moon = love.graphics.newImage('res/moon.png')

function love.load()
    love.window.setTitle('Bouncing Android')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(buildings_3, 0, 0)
    love.graphics.draw(buildings_2, 0, 0)
    love.graphics.draw(buildings_1, 0, 0)

    love.graphics.draw(moon, 50, 300)
end