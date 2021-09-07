TransitionState = BaseState:new()

function TransitionState:new(def)
    local this = {
        ["y"] = -VIRTUAL_HEIGHT,
        ["callback"] = function()
            gStateStack:pop()
            def.callback()
        end
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function TransitionState:enter()
    Timer:tween(
        2,
        {
            [self] = {["y"] = 0}
        },
        function()
            self.callback()
        end
    )
end

function TransitionState:update(dt)
    Timer:update(dt)
end

function TransitionState:render()
    love.graphics.setColor(0.09, 0.09, 0.09)
    love.graphics.rectangle("fill", 0, self.y, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
