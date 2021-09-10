PlayState = BaseState:new()

function PlayState:enter()
    self.level = {}
    self:initializeLevel()
end

function PlayState:update(dt)
    if love.keyboard.waspressed("escape") then
        gStateStack:pop()
        gStateStack:push(TitleState:new())
    end

    self.level.player:update(dt)

    for k, enemy in pairs(self.level.enemies) do
        enemy:update(dt)

        if not enemy.inPlay then
            table.remove(self.level.enemies, k)
        end
    end
end

function PlayState:render()
    love.graphics.setColor(0.09, 0.09, 0.09)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    for k, wall in pairs(self.level.walls) do
        wall:render()
    end

    for k, enemy in pairs(self.level.enemies) do
        enemy:render()
    end

    self.level.player:render()
end

function PlayState:initializeLevel()
    local level = LEVELS[love.math.random(#LEVELS)]:gsub(" ", "")
    local sequence, rows = level:gsub("\n", "")
    local columns = level:find("\n") - 1

    local widthUnit = VIRTUAL_WIDTH / columns
    local heightUnit = VIRTUAL_HEIGHT / rows

    local level = {
        ["room"] = {
            ["x"] = widthUnit / 2 - WALL_SIZE / 2,
            ["y"] = heightUnit / 2 - WALL_SIZE / 2,
            ["width"] = VIRTUAL_WIDTH - widthUnit + WALL_SIZE,
            ["height"] = VIRTUAL_HEIGHT - heightUnit + WALL_SIZE
        },
        ["walls"] = {},
        ["player"] = nil,
        ["enemies"] = {}
    }

    for row = 1, rows do
        local isWall = false

        local yWall = row
        local xWall = 0
        local widthWall = 0

        for column = 1, columns do
            local index = column + (row - 1) * columns
            local character = sequence:sub(index, index)

            if character == "x" then
                if not isWall then
                    isWall = true
                    xWall = column
                end
                widthWall = widthWall + 1
            end

            if character ~= "x" or column == columns then
                if isWall then
                    if widthWall > 1 then
                        local x = (xWall - 1) * widthUnit + widthUnit / 2 - WALL_SIZE / 2
                        local y = (yWall - 1) * heightUnit + heightUnit / 2 - WALL_SIZE / 2
                        local width = (widthWall - 1) * widthUnit + WALL_SIZE
                        local height = WALL_SIZE

                        local wall = Wall:new(x, y, width, height)
                        table.insert(level.walls, wall)
                    end
                    isWall = false
                    widthWall = 0
                end
            end

            if character == "p" then
                local x = (column - 1) * widthUnit + widthUnit / 2 - SPRITE_SIZE / 2
                local y = (row - 1) * heightUnit + heightUnit / 2 - SPRITE_SIZE / 2
                level.player = Player:new(x, y, level)
            end

            if character == "e" then
                local x = (column - 1) * widthUnit + widthUnit / 2 - SPRITE_SIZE / 2
                local y = (row - 1) * heightUnit + heightUnit / 2 - SPRITE_SIZE / 2
                local enemy = Enemy:new(x, y, level)

                table.insert(level.enemies, enemy)
            end
        end
    end

    for column = 1, columns do
        local isWall = false

        local xWall = column
        local yWall = 0
        local heightWall = 0

        for row = 1, rows do
            local index = column + (row - 1) * columns
            local character = sequence:sub(index, index)

            if character == "x" then
                if not isWall then
                    isWall = true
                    yWall = row
                end
                heightWall = heightWall + 1
            end

            if character ~= "x" or row == rows then
                if isWall then
                    if heightWall > 1 then
                        local x = (xWall - 1) * widthUnit + widthUnit / 2 - WALL_SIZE / 2
                        local y = (yWall - 1) * heightUnit + heightUnit / 2 - WALL_SIZE / 2
                        local width = WALL_SIZE
                        local height = (heightWall - 1) * heightUnit + WALL_SIZE

                        local wall = Wall:new(x, y, width, height)
                        table.insert(level.walls, wall)
                    end
                    isWall = false
                    heightWall = 0
                end
            end
        end
    end

    self.level = level
end
