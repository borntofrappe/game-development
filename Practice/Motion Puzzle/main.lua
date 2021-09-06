require "src/Dependencies"

local backgroundTiles

function love.load()
    love.window.setTitle(TITLE)

    love.window.setMode(WINDOW_SIZE, WINDOW_SIZE)
    love.graphics.setBackgroundColor(0.62, 0.7, 0.62)

    gTexture = love.graphics.newImage("res/graphics/spritesheet.png")

    gQuads = {
        ["levels"] = GenerateQuadsLevels(gTexture),
        ["tiles"] = GenerateQuadsTiles(gTexture),
        ["highlight"] = GenerateQuadsHighlight(gTexture),
        ["pointer"] = GenerateQuadsPointer(gTexture),
        ["selection"] = GenerateQuadsSelection(gTexture)
    }

    gFonts = {
        ["large"] = love.graphics.newFont("res/fonts/font.ttf", 64),
        ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
    }

    backgroundTiles = love.graphics.newSpriteBatch(gTexture)

    local WINDOW_DIMENSIONS = math.floor(WINDOW_SIZE / TILE_SIZE)
    for column = 1, WINDOW_DIMENSIONS do
        for row = 1, WINDOW_DIMENSIONS do
            backgroundTiles:add(gQuads.tiles[2], (column - 1) * TILE_SIZE, (row - 1) * TILE_SIZE)
        end
    end

    gStateMachine =
        StateMachine:new(
        {
            ["start"] = function()
                return StartState:new()
            end,
            ["play"] = function()
                return PlayState:new()
            end,
            ["finish"] = function()
                return FinishState:new()
            end
        }
    )

    gStateMachine:change("start")

    love.keyboard.keypressed = {}
    love.mouse.buttonpressed = {}
end

function love.keypressed(key)
    love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
    return love.keyboard.keypressed[key]
end

function love.mousepressed(x, y, button)
    love.mouse.buttonpressed[button] = true
end

function love.mouse.waspressed(button)
    return love.mouse.buttonpressed[button]
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keypressed = {}
    love.mouse.buttonpressed = {}
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(backgroundTiles)

    gStateMachine:render()
end
