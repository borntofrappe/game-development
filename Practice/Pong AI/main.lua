Class = require("res/class")

require "Paddle"
require "Puck"

WINDOW = {
    width = 360,
    height = 460,
    options = {
        fullscreen = false
    },
    padding = 8
}

PADDLE = {
    width = 60,
    height = 10,
    scope = {
        min = WINDOW.height / 3,
        max = WINDOW.height
    },
    speed = 200
}

PUCK = {
    size = 10,
    dx = {-150, 150},
    dy = {
        min = 80,
        max = 160
    }
}

POINTS_GOAL = 5

function love.load()
    love.window.setTitle("Pong AI")
    love.window.setMode(WINDOW.width, WINDOW.height, WINDOW.options)

    fonts = {
        normal = love.graphics.newFont("res/font.ttf", 16),
        large = love.graphics.newFont("res/font.ttf", 28),
        title = love.graphics.newFont("res/font.ttf", 36)
    }
    love.graphics.setFont(fonts.normal)
    love.graphics.setLineWidth(2)

    messages = {
        {
            text = "Support",
            font = fonts.large,
            center = {
                x = WINDOW.width / 2,
                y = WINDOW.height / 4
            }
        },
        {
            text = "Support",
            font = fonts.large,
            center = {
                x = WINDOW.width / 2,
                y = WINDOW.height * 3 / 4
            }
        }
    }

    for i, message in ipairs(messages) do
        message.text = message.text:upper()
        message.width = message.font:getWidth(message.text) * 1.1
        message.x = message.center.x - message.width / 2
        message.height = message.font:getHeight()
        message.y = message.center.y - message.height / 2
    end

    message = {
        text = "That's it!",
        font = fonts.title,
        center = {
            x = WINDOW.width / 2,
            y = WINDOW.height / 4
        }
    }

    message.text = message.text:upper()
    message.width = message.font:getWidth(message.text) * 1.1
    message.x = message.center.x - message.width / 2
    message.height = message.font:getHeight()
    message.y = message.center.y - message.height / 2

    math.randomseed(os.time())

    game = {
        state = "waiting",
        winner = "ai",
        points = 0,
        support = 1,
        supports = {0, 0},
        score = 0,
        message = ""
    }

    ai1 = Paddle(WINDOW.width / 2 - PADDLE.width / 2, WINDOW.padding)
    ai2 = Paddle(WINDOW.width / 2 - PADDLE.width / 2, WINDOW.height - WINDOW.padding - PADDLE.height)

    puck = Puck(WINDOW.width / 2, WINDOW.height / 2)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "up" or key == "down" or key == "tab" then
        game.support = game.support == 1 and 2 or 1
    end

    if key == "return" then
        if game.state == "scoring" then
            puck:reset()

            ai1.points = 0
            ai2.points = 0

            game.supports = {0, 0}
            game.state = "waiting"
        elseif game.state == "waiting" then
            if game.support == 1 then
                puck.dy = math.abs(puck.dy) * -1

                ai1.looksAhead = true

                game.supports[1] = game.supports[1] + 1
            else
                puck.dy = math.abs(puck.dy)

                ai2.looksAhead = true

                game.supports[2] = game.supports[2] + 1
            end
            game.state = "playing"
        end
    end
end

function love.update(dt)
    if game.state == "playing" then
        puck:update(dt)

        ai1:update(dt)
        ai2:update(dt)

        if ai1.looksAhead and puck.dy < 0 and math.abs(ai1.y + ai1.height - puck.y) < ai1.scope then
            ai1:target(puck)
        end

        if ai2.looksAhead and puck.dy > 0 and math.abs(ai2.y - puck.y + puck.height) < ai2.scope then
            ai2:target(puck)
        end

        if puck.x <= 0 then
            puck.x = 0
            puck.dx = math.abs(puck.dx)

            ai1.looksAhead = true
            ai2.looksAhead = true
        elseif puck.x >= WINDOW.width - puck.width then
            puck.x = WINDOW.width - puck.width
            puck.dx = math.abs(puck.dx) * -1

            ai1.looksAhead = true
            ai2.looksAhead = true
        end

        if puck.y <= 0 then
            ai2:score(game.support == 1 and 2 or 1)

            if ai2.points >= POINTS_GOAL then
                game.winner = "ai2"
                game.points = ai2.points
                game.score = game.supports[2] / (game.supports[1] + game.supports[2]) * 100
                if game.score > 50 then
                    game.message = "that certainly helped!"
                else
                    game.message = "you certainly tried..."
                end
                game.state = "scoring"
            else
                puck:reset()
                game.state = "waiting"
            end
        elseif puck.y >= WINDOW.height then
            ai1:score(game.support == 1 and 1 or 2)

            if ai1.points >= POINTS_GOAL then
                game.winner = "ai1"
                game.points = ai1.points
                game.score = game.supports[1] / (game.supports[1] + game.supports[2]) * 100
                if game.score > 50 then
                    game.message = "that certainly helped!"
                else
                    game.message = "you certainly tried..."
                end
                game.state = "scoring"
            else
                puck:reset()
                game.state = "waiting"
            end
        end

        if puck:collides(ai1) then
            puck.y = ai1.y + ai1.height
            puck.dy = math.abs(puck.dy) * 1.2

            ai2.looksAhead = true
        elseif puck:collides(ai2) then
            puck.y = ai2.y - puck.height
            puck.dy = math.abs(puck.dy) * -1 * 1.2

            ai1.looksAhead = true
        end
    end
end

function love.draw()
    love.graphics.clear(1, 1, 1)

    if game.state == "waiting" then
        love.graphics.setFont(fonts.normal)
        love.graphics.setColor(0.02, 0.02, 0.01)
        love.graphics.print("Points: " .. ai1.points, 8, WINDOW.height / 2 - 16)
        love.graphics.printf("Points: " .. ai2.points, -8, WINDOW.height / 2, WINDOW.width, "right")

        if game.support == 1 then
            love.graphics.setFont(messages[1].font)
            love.graphics.setColor(0.02, 0.02, 0.01)
            love.graphics.rectangle("fill", messages[1].x, messages[1].y, messages[1].width, messages[1].height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(messages[1].text, messages[1].x, messages[1].y + 2, messages[1].width, "center")
        else
            love.graphics.setFont(messages[2].font)
            love.graphics.setColor(0.02, 0.02, 0.01)
            love.graphics.rectangle("fill", messages[2].x, messages[2].y, messages[2].width, messages[2].height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(messages[2].text, messages[2].x, messages[2].y + 2, messages[2].width, "center")
        end
    end

    if game.state == "scoring" then
        love.graphics.setColor(0.02, 0.02, 0.01)
        love.graphics.setFont(fonts.normal)
        love.graphics.printf(
            game.winner .. " won with " .. game.points .. " points",
            0,
            WINDOW.height / 2,
            WINDOW.width,
            "center"
        )
        love.graphics.printf("...your support?", 0, WINDOW.height / 2 + 30, WINDOW.width, "center")
        love.graphics.printf(game.message, 0, WINDOW.height / 2 + 92, WINDOW.width, "center")
        love.graphics.setFont(fonts.large)
        love.graphics.printf(string.format("%.2f%%", game.score), 0, WINDOW.height / 2 + 56, WINDOW.width, "center")

        love.graphics.setFont(message.font)
        love.graphics.setColor(0.02, 0.02, 0.01)
        love.graphics.rectangle("fill", message.x, message.y, message.width, message.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(message.text, message.x, message.y + 2, message.width, "center")
    end

    love.graphics.setColor(0.02, 0.02, 0.01)
    puck:render()
    ai1:render()
    ai2:render()
end
