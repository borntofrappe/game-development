require "src/Dependencies"

local firework, target, particles

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle("Detonate")
    love.graphics.setBackgroundColor(0.05, 0, 0.1)

    target = Target:new()
    firework = Firework:new()
    particles = Particles:new()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "return" then
        target.inPlay = false
        firework.inPlay = false

        if target.inFocus then
            particles:explode(firework)
        else
            particles:fizzle(firework)
        end
    end
end

function love.update(dt)
    firework:update(dt)
    particles:update(dt)

    if firework.y > target.y and firework.y < target.y + target.size then
        target.inFocus = true
    else
        target.inFocus = false
    end
end

function love.draw()
    target:render()
    firework:render()
    particles:render()
end
