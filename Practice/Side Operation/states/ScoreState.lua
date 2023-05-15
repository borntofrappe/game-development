ScoreState = Class({__includes = BaseState})

function ScoreState:enter(params)
    self.score = params.score

    self.trophy = false
    if params.trophy then
        local image = gImages["trophy"]
        local width_image = image:getWidth()
        local height_image = image:getHeight()
        self.trophy = {
            ["image"] = image,
            ["x"] = math.floor(VIRTUAL_WIDTH / 2 - width_image / 2),
            ["y"] = math.floor(VIRTUAL_HEIGHT / 2 - height_image / 2)
        }
    end

    local text_title = string.upper("Timeout!\n") .. string.format("%.2fs", self.score)
    local width_title = gFont:getWidth(text_title) * 1.1
    local height_title = gFont:getHeight() * 2
    self.title = {
        ["text"] = text_title,
        ["width"] = width_title,
        ["height"] = height_title,
        ["x"] = VIRTUAL_WIDTH / 2 - width_title / 2,
        ["y"] = VIRTUAL_HEIGHT / 4 - height_title / 2
    }

    local text_message = "Press\nto replay"
    local width_message = gFont:getWidth(text_message)
    local height_message = gFont:getHeight() * 2
    self.message = {
        ["text"] = text_message,
        ["x"] = 0,
        ["y"] = VIRTUAL_HEIGHT * 3 / 4 - height_message / 2,
        ["width"] = VIRTUAL_WIDTH,
        ["align"] = "center"
    }
end

function ScoreState:update(dt)
    if love.keyboard.was_pressed("return") or love.mouse.button_pressed[1] then
        gStateMachine:change("countdown")
    end
end

function ScoreState:render()
    love.graphics.draw(gImages["progress"], 0, 0)

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", self.title["x"], self.title["y"], self.title["width"], self.title["height"])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.title["text"], self.title["x"], self.title["y"], self.title["width"], "center")

    if (self.trophy) then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.trophy["image"], self.trophy.x, self.trophy.y)
    end

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.printf(
        self.message["text"],
        self.message["x"],
        self.message["y"],
        self.message["width"],
        self.message["align"]
    )
end
