Enemy = Entity:new()

local ENEMY_ANIMATION_INTERVAL = 0.2

function Enemy:new(x, y, state)
  local state = state or "idle"
  local this = {
    ["state"] = state
  }

  local def = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = SPRITE_SIZE,
    ["quads"] = "enemy"
  }

  local stateMachine =
    StateMachine:new(
    {
      ["idle"] = function()
        return EnemyIdleState:new(this)
      end,
      ["walking-up"] = function()
        return EnemyWalkingState:new(this, "up")
      end,
      ["walking-right"] = function()
        return EnemyWalkingState:new(this, "right")
      end,
      ["walking-down"] = function()
        return EnemyWalkingState:new(this, "down")
      end,
      ["walking-left"] = function()
        return EnemyWalkingState:new(this, "left")
      end
    }
  )

  stateMachine:change(state)
  def.stateMachine = stateMachine

  -- :changeState sets up the animation in place of the individual states
  -- as the function not called when the enemy is initialized it is necessary to set up the first animation
  local frames = {}
  for frame = 1, #gQuads.enemy[state] do
    table.insert(frames, frame)
  end
  def.currentAnimation = Animation:new(frames, ENEMY_ANIMATION_INTERVAL)

  Entity.init(this, def)

  self.__index = self
  setmetatable(this, self)

  return this
end

function Enemy:update(dt)
  Entity.update(self, dt)
end

function Enemy:changeState(state, params)
  self.state = state

  local frames = {}
  for frame = 1, #gQuads.enemy[state] do
    table.insert(frames, frame)
  end
  self.currentAnimation = Animation:new(frames, ENEMY_ANIMATION_INTERVAL)

  self.stateMachine:change(state, params)
end

function Enemy:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTexture,
    gQuads[self.quads][self.state][self.currentAnimation:getCurrentFrame()],
    math.floor(self.x),
    math.floor(self.y)
  )
end
