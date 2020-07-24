ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
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
        VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH,
        'center'
    )

    love.graphics.setFont(font_normal)
    love.graphics.printf(
        'Press enter to play once more',
        0,
        VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH,
        'center'
    )
end