WINDOW_WIDTH = 336
WINDOW_HEIGHT = 336

ERVAL = 0.2

function love.load()
    love.window.setTitle("Motion Puzzle")

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    gFonts = {
        ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24),
        ["small"] = love.graphics.newFont("res/fonts/font.ttf", 16)
    }

    love.graphics.setFont(gFonts.normal)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Bonne chance", 8, 8)
end
