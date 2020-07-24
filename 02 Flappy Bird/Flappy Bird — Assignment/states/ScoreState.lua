ScoreState = Class{__includes = BaseState}

function ScoreState:init()
    medals = {
        { points = 5, image = love.graphics.newImage('res/graphics/medal-points-5.png') },
        { points = 10, image = love.graphics.newImage('res/graphics/medal-points-10.png') },
        { points = 15, image = love.graphics.newImage('res/graphics/medal-points-15.png') }
    }
    table.sort(medals, function(a, b) return a.points < b.points end)
    self.medals = medals
end

function ScoreState:enter(params)
    self.score = params.score
    
    medals = {}
    for k, medal in pairs(self.medals) do
        if self.score >= medal.points then
            table.insert(medals, medal.image)
        end
    end

    self.medals = medals
end

function ScoreState:update(dt)
    if love.keyboard.waspressed('enter') or love.keyboard.waspressed('return') then
        gStateMachine:change('countdown')
    end

    if love.mouse.waspressed then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(font_big)
    love.graphics.printf(
        'Score: ' .. self.score,
        0,
        VIRTUAL_HEIGHT / 2 - 48,
        VIRTUAL_WIDTH,
        'center'
    )

    love.graphics.setFont(font_normal)
    love.graphics.printf(
        'Press enter to play once more',
        0,
        VIRTUAL_HEIGHT / 2 + 8,
        VIRTUAL_WIDTH,
        'center'
    )

    for i, medal in ipairs(self.medals) do
        love.graphics.draw(medal, VIRTUAL_WIDTH / 2 - 12 - 28 * (#self.medals - 1) + 56 * (i - 1), VIRTUAL_HEIGHT / 1.5)
    end
end