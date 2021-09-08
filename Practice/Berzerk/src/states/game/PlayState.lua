PlayState = BaseState:new()

function PlayState:enter()
    self.padding = ROOM_PADDING
    self.width = VIRTUAL_WIDTH - self.padding * 2
    self.height = VIRTUAL_HEIGHT - self.padding * 2

    self.walls = {}
    self.player = nil
    self.enemies = nil
    self:generateRoom()
end

function PlayState:update(dt)
    if love.keyboard.waspressed("escape") then
        gStateStack:pop()
        gStateStack:push(TitleState:new())
    end

    -- debugging
    if love.keyboard.waspressed("r") then
        self:generateRoom()
    end
end

function PlayState:render()
    love.graphics.translate(self.padding, self.padding)
    love.graphics.setColor(0.427, 0.459, 0.906)
    for k, wall in pairs(self.walls) do
        wall:render()
    end

    love.graphics.setColor(1, 1, 1)

    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end

    self.player:render()
end

function PlayState:generateRoom()
    local index
    repeat
        index = love.math.random(#ROOMS)
    until index ~= self.index
    self.index = index

    local room = ROOMS[self.index]:gsub(" ", "")
    local sequence, rows = room:gsub("\n", "")
    local columns = room:find("\n") - 1

    local widthUnit = self.width / (columns - 1)
    local heightUnit = self.height / (rows - 1)

    local walls = {}
    local free = {}

    for row = 1, rows do
        local isWall = false

        local yWall = row - 1
        local xWall = 0
        local widthWall = 0

        for column = 1, columns do
            local index = column + (row - 1) * columns
            local character = sequence:sub(index, index)

            if character == "o" or column == columns then
                if character == "x" then
                    widthWall = widthWall + 1
                else
                    table.insert(
                        free,
                        {
                            ["column"] = column,
                            ["row"] = row
                        }
                    )
                end
                if isWall and widthWall >= 1 then
                    local wall =
                        Wall:new(
                        xWall * widthUnit - WALL_SIZE / 2,
                        yWall * heightUnit - WALL_SIZE / 2,
                        widthWall * widthUnit + WALL_SIZE,
                        WALL_SIZE
                    )
                    table.insert(walls, wall)
                end
                isWall = false
                widthWall = 0
            else
                if isWall then
                    widthWall = widthWall + 1
                else
                    xWall = column - 1
                    widthWall = 0
                    isWall = true
                end
            end
        end
    end

    for column = 1, columns do
        local isWall = false

        local xWall = column - 1
        local yWall = 0
        local heightWall = 0

        for row = 1, rows do
            local index = column + (row - 1) * columns
            local character = sequence:sub(index, index)

            if character == "o" or row == rows then
                if character == "x" then
                    heightWall = heightWall + 1
                end
                if isWall and heightWall >= 1 then
                    local wall =
                        Wall:new(
                        xWall * widthUnit - WALL_SIZE / 2,
                        yWall * heightUnit - WALL_SIZE / 2,
                        WALL_SIZE,
                        heightWall * heightUnit + WALL_SIZE
                    )
                    table.insert(walls, wall)
                end
                isWall = false
                heightWall = 0
            else
                if isWall then
                    heightWall = heightWall + 1
                else
                    yWall = row - 1
                    heightWall = 0
                    isWall = true
                end
            end
        end
    end

    self.walls = walls

    local playerPosition = table.remove(free, love.math.random(#free))
    self.player = Player:new((playerPosition.column - 1) * widthUnit, (playerPosition.row - 1) * heightUnit)

    local enemies = {}
    for i = 1, 3 do
        local enemyPosition = table.remove(free, love.math.random(#free))
        local enemy = Enemy:new((enemyPosition.column - 1) * widthUnit, (enemyPosition.row - 1) * heightUnit)
        table.insert(enemies, enemy)
    end
    self.enemies = enemies
end
