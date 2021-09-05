require "src/Dependencies"

local spriteBatch

function love.load()
    love.window.setTitle("Motion Puzzle")

    love.window.setMode(WINDOW_SIZE, WINDOW_SIZE)
    love.graphics.setBackgroundColor(0.62, 0.7, 0.62)

    gTexture = love.graphics.newImage("res/graphics/spritesheet.png")

    gQuads = {
        ["tiles"] = GenerateQuadsTiles(gTexture)
    }

    spriteBatch = love.graphics.newSpriteBatch(gTexture)

    local WINDOW_DIMENSIONS = math.floor(WINDOW_SIZE / TILE_SIZE)
    for column = 1, WINDOW_DIMENSIONS do
        for row = 1, WINDOW_DIMENSIONS do
            spriteBatch:add(gQuads.tiles[2], (column - 1) * TILE_SIZE, (row - 1) * TILE_SIZE)
        end
    end

    gFonts = {
        ["large"] = love.graphics.newFont("res/fonts/font.ttf", 56),
        ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
    }

    gStateMachine =
        StateMachine:new(
        {
            ["title"] = function()
                return TitleState:new()
            end,
            ["play"] = function()
                return PlayState:new()
            end
        }
    )

    gStateMachine:change("title")

    love.keyboard.keypressed = {}
end

function love.keypressed(key)
    love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
    return love.keyboard.keypressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keypressed = {}
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(spriteBatch)

    gStateMachine:render()
end
