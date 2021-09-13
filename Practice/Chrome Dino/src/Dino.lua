Dino = {}

local INTERVAL_ANIMATION = 0.12
local DINO_INSET = {
    ["x"] = 4,
    ["y"] = 2
}

function Dino:new(state)
    local state = state or "idle"

    local x = DINO_INSET.x
    local y = VIRTUAL_HEIGHT - (DINO_STATES[state].height + DINO_INSET.y)
    local width = DINO_STATES[state].width
    local height = DINO_STATES[state].height

    local frames = {}
    for i = 1, DINO_STATES[state].frames do
        table.insert(frames, i)
    end
    local animation = Animation:new(frames, INTERVAL_ANIMATION)

    local this = {
        ["x"] = x,
        ["yStart"] = y,
        ["y"] = y,
        ["dy"] = 0,
        ["width"] = width,
        ["height"] = height,
        ["state"] = state,
        ["quads"] = state,
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
    local previousHeight = DINO_STATES[self.state].height

    local width = DINO_STATES[state].width
    local height = DINO_STATES[state].height

    self.state = state

    self.y = self.y + previousHeight - height

    self.width = width
    self.height = height

    local frames = {}
    for frame = 1, DINO_STATES[state].frames do
        table.insert(frames, frame)
    end
    self.animation = Animation:new(frames, INTERVAL_ANIMATION)

    self.stateMachine:change(state, params)
end

function Dino:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        gTextures["spritesheet"],
        gQuads["dino"][self.state][self.animation:getCurrentFrame()],
        self.x,
        self.y
    )
end
