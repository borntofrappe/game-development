Pokemon = Class {}

function Pokemon:init(def)
  local def = def or {}

  local entry = def.entry or POKEDEX[math.random(#POKEDEX)]

  self.name = entry.name

  self.level = 5
  self.exp = 15
  self.expToLevel = math.floor(self.level * self.level * 0.75)

  self.baseStats = {}
  self.stats = {}
  self.IVs = {}

  for k, stat in pairs(entry.stats) do
    local i, j = string.find(k, "base")
    if i then
      local key = string.sub(k, j + 1, -1):lower()
      self.baseStats[key] = stat
      self.stats[key] = stat
    else
      local i = string.find(k, "IV")
      if i then
        local key = string.sub(k, 1, i - 1):lower()
        self.IVs[key] = stat
      end
    end
  end

  self.type = def.type or "front"

  self.width = POKEMON_WIDTH
  self.height = POKEMON_HEIGHT

  self.x = def.x or VIRTUAL_WIDTH / 2 - self.width / 2
  self.y = def.y or VIRTUAL_HEIGHT / 2 - self.height / 2
end

function Pokemon:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["pokemon"][self.name][self.type], self.x, self.y)
end

function Pokemon:levelUp()
  self.level = self.level + 1
  self.exp = 0
  self.expToLevel = math.floor(self.level * self.level * 0.75)

  local stats = {"hp", "attack", "defense", "speed"}
  local increments = {}

  for i = 1, #stats do
    local stat = stats[i]
    increments[i] = {
      ["stat"] = stat,
      ["value"] = 0
    }

    for j = 1, 3 do
      local diceRoll = math.random(1, 6)
      if self.IVs[stat] > diceRoll then
        increments[i].value = 1
        if stat == "hp" then
          self.baseStats[stat] = self.baseStats[stat] + 1
        else
          self.stats[stat] = self.stats[stat] + 1
        end
        break
      end
    end
  end

  return increments
end
