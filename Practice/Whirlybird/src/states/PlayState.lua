PlayState = BaseState:new()

local FALLING_DELAY = 1.5

local INTERACTABLE_PADDING = 50
local INTERACTABLE_GAP = 200
local INTERACTABLE_X = {INTERACTABLE_PADDING, WINDOW_WIDTH - INTERACTABLE_PADDING}

function PlayState:enter(params)
  self.player = params and params.player or Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  if not params then
    self.player:hop()
  end

  self.scrollY = 0

  local interactables = {}
  local y = WINDOW_HEIGHT - INTERACTABLE_PADDING

  for i = 1, math.floor(WINDOW_HEIGHT * 2 / INTERACTABLE_GAP) do
    local x = math.random(INTERACTABLE_X[1], INTERACTABLE_X[2])
    table.insert(interactables, Interactable:new(x, y))
    y = y - INTERACTABLE_GAP
  end

  self.interactables = interactables

  self.timer = 0
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change(
      "start",
      {
        ["player"] = self.player
      }
    )
  end

  self.player:update(dt)

  if self.player.dy > 0 then
    for i, interactable in ipairs(self.interactables) do
      if self.player:isOnTop(interactable) then
        self.player.y = interactable.y - self.player.height
        self.player:bounce()
        break
      end
    end
  end

  for i, interactable in ipairs(self.interactables) do
    if interactable.y > WINDOW_HEIGHT - self.scrollY then
      local x = math.random(INTERACTABLE_X[1], INTERACTABLE_X[2])
      local y = self.interactables[#self.interactables].y - INTERACTABLE_GAP

      table.insert(self.interactables, Interactable:new(x, y))

      table.remove(self.interactables, i)
      break
    end
  end

  if self.player.dy < 0 and self.player.y < UPPER_THRESHOLD - self.scrollY then
    self.scrollY = UPPER_THRESHOLD - self.player.y
  end

  if self.player.y > LOWER_THRESHOLD - self.scrollY then
    self.scrollY = LOWER_THRESHOLD - self.player.y

    self.timer = self.timer + dt
    if self.timer > FALLING_DELAY then
      gStateMachine:change(
        "falling",
        {
          ["player"] = self.player,
          ["scrollY"] = self.scrollY
        }
      )
    end
  end
end

function PlayState:render()
  love.graphics.translate(0, math.floor(self.scrollY))

  love.graphics.setColor(1, 1, 1)
  for k, interactable in pairs(self.interactables) do
    interactable:render()
  end

  self.player:render()
end
