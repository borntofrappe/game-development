PlayState = BaseState:new()

local WALL_SIZE = 4

function PlayState:enter()
    self.level = {}
    self:initializeLevel()
end

function PlayState:update(dt)
    Timer:update(dt)

    if love.keyboard.waspressed("escape") then
        gStateStack:pop()
        gStateStack:push(TitleState:new())
    end

    self.level.player:update(dt)

    for k, enemy in pairs(self.level.enemies) do
        enemy:update(dt)
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

    local wallCharacter = "x"
    local wallSegments = {}

    for row = 1, rows do
        local wallCounter = 0

        for column = 1, columns do
            local index = column + (row - 1) * columns
            local character = sequence:sub(index, index)

            if character == "x" then
                wallCounter = wallCounter + 1
            else
                if wallCounter > 1 then
                    table.insert(
                        wallSegments,
                        {
                            ["column"] = column - wallCounter,
                            ["row"] = row,
                            ["width"] = wallCounter
                        }
                    )
                end

                wallCounter = 0
            end

            if column == columns then
                if wallCounter > 1 then
                    table.insert(
                        wallSegments,
                        {
                            ["column"] = column - wallCounter + 1,
                            ["row"] = row,
                            ["width"] = wallCounter
                        }
                    )
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
        local wallCounter = 0

        for row = 1, rows do
            local index = column + (row - 1) * columns
            local character = sequence:sub(index, index)

            if character == "x" then
                wallCounter = wallCounter + 1
            else
                if wallCounter > 1 then
                    table.insert(
                        wallSegments,
                        {
                            ["row"] = row - wallCounter,
                            ["column"] = column,
                            ["height"] = wallCounter
                        }
                    )
                end

                wallCounter = 0
            end

            if row == rows then
                if wallCounter > 1 then
                    table.insert(
                        wallSegments,
                        {
                            ["row"] = row - wallCounter + 1,
                            ["column"] = column,
                            ["height"] = wallCounter
                        }
                    )
                end
            end
        end
    end

    for k, wall in pairs(wallSegments) do
        local x = (wall.column - 1) * widthUnit + widthUnit / 2 - WALL_SIZE / 2
        local y = (wall.row - 1) * heightUnit + heightUnit / 2 - WALL_SIZE / 2
        local width = wall.width and (wall.width - 1) * widthUnit + WALL_SIZE or WALL_SIZE
        local height = wall.height and (wall.height - 1) * heightUnit + WALL_SIZE or WALL_SIZE

        local wall = Wall:new(x, y, width, height)
        table.insert(level.walls, wall)
    end

    self.level = level
end
