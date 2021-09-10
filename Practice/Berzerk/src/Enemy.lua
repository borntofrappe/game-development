Enemy = Entity:new()

local ENEMY_ANIMATION_INTERVAL = 0.15
local ENEMY_LASERS = {3, 7}

function Enemy:new(x, y, level, state)
  local state = state or "idle"

  -- set up initial animation
  -- following animations are managed by `:changeState`
  local frames = {}
  for frame = 1, #gQuads.enemy[state] do
    table.insert(frames, frame)
  end
  local currentAnimation = Animation:new(frames, ENEMY_ANIMATION_INTERVAL)
  -- initialize to a random frame to avoid having the enemies all in sync
  currentAnimation.index = frames[love.math.random(#frames)]

  local this = {
    ["state"] = state,
    ["currentAnimation"] = currentAnimation,
    ["inPlay"] = true,
    ["ammunitions"] = love.math.random(ENEMY_LASERS[1], ENEMY_LASERS[2]),
    ["lasers"] = {},
    ["particles"] = {}
  }

  local def = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = SPRITE_SIZE,
    ["height"] = SPRITE_SIZE,
    ["quads"] = "enemy",
    ["level"] = level
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
      end,
      ["shooting"] = function()
        return EnemyShootingState:new(this)
      end,
      ["lose"] = function()
        return EnemyLoseState:new(this)
      end
    }
  )

  stateMachine:change(state)
  def.stateMachine = stateMachine

  Entity.init(this, def)

  self.__index = self
  setmetatable(this, self)

  return this
end

function Enemy:update(dt)
  if self.inPlay then
    Entity.update(self, dt)
  end

  for k, laser in pairs(self.lasers) do
    laser:update(dt)
    for j, enemy in pairs(self.level.enemies) do
      if laser:collides(enemy) and (self.x ~= enemy.x or self.y ~= enemy.y) then
        enemy:changeState("lose")
        laser.inPlay = false
        break
      end
    end

    if laser:collides(self.level.player) then
      self.level.player:changeState("lose")
      laser.inPlay = false
    end

    for j, wall in pairs(self.level.walls) do
      if laser:collides(wall) then
        laser.inPlay = false
        break
      end
    end

    if not laser.inPlay then
      table.remove(self.lasers, k)
    end
  end
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
  for k, laser in pairs(self.lasers) do
    laser:render()
  end

  if self.inPlay then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
      gTexture,
      gQuads[self.quads][self.state][self.currentAnimation:getCurrentFrame()],
      math.floor(self.x),
      math.floor(self.y)
    )
  end
end
