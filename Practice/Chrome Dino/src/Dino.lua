Dino = {}

local INTERVAL_ANIMATION = 0.12
local DINO_INSET = {
    ["x"] = 4,
    ["y"] = 5
}

function Dino:new(ground, state)
    local state = state or "idle"

    local width = DINO[state].width
    local height = DINO[state].height

    local x = ground.x + DINO_INSET.x
    local y = ground.y - height + DINO_INSET.y

    local hitRadius = ((width ^ 2 + height ^ 2) ^ 0.5) / 3

    local frames = {}
    for i = 1, DINO[state].frames do
        table.insert(frames, i)
    end
    local animation = Animation:new(frames, INTERVAL_ANIMATION)

    local this = {
        ["yStart"] = y,
        ["x"] = x,
        ["y"] = y,
        ["dy"] = 0,
        ["width"] = width,
        ["height"] = height,
        ["hitRadius"] = hitRadius,
        ["state"] = state,
        ["animation"] = animation
    }

    local stateMachine =
        StateMachine:new(
        {
            ["idle"] = function()
                return DinoIdleState:new(this)
            end,
            ["run"] = function()
                return DinoRunningState:new(this)
            end,
            ["jump"] = function()
                return DinoJumpingState:new(this)
            end,
            ["duck"] = function()
                return DinoDuckingState:new(this)
            end,
            ["stop"] = function()
                return DinoStoppedState:new(this)
            end
        }
    )

    stateMachine:change(state)
    this.stateMachine = stateMachine

    self.__index = self
    setmetatable(this, self)

    return this
end

function Dino:update(dt)
    self.stateMachine:update(dt)
    self.animation:update(dt)
end

function Dino:changeState(state, params)
    local previousHeight = DINO[self.state].height

    local width = DINO[state].width
    local height = DINO[state].height

    self.y = self.y + previousHeight - height

    self.width = width
    self.height = height

    self.hitRadius = ((self.width ^ 2 + self.height ^ 2) ^ 0.5) / 3

    local frames = {}
    for frame = 1, DINO[state].frames do
        table.insert(frames, frame)
    end
    self.animation = Animation:new(frames, INTERVAL_ANIMATION)

    self.state = state
    self.stateMachine:change(state, params)
end

function Dino:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        gTextures["spritesheet"],
        gQuads["dino"][self.state][self.animation:getCurrentFrame()],
        math.floor(self.x),
        math.floor(self.y)
    )

    --[[
        love.graphics.setColor(0, 1, 0, 0.5)
        love.graphics.circle("fill", self.x + self.width / 2, self.y + self.height / 2, self.hitRadius)
    --]]
end

function Dino:collides(collidable)
    return (((self.x + self.width / 2) - (collidable.x + collidable.width / 2)) ^ 2 +
        ((self.y + self.height / 2) - (collidable.y + collidable.height / 2)) ^ 2) ^
        0.5 <
        self.hitRadius + collidable.hitRadius
end
