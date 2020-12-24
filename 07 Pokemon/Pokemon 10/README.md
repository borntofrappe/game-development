Add pokemon stats.

## Stats

`constants.lua` is updated so to have `POKEDEX` describe the pokemons in tables. The idea is to have each entry describe the creature with its name and statistics. For instance and for the first pokemon.

```lua
entry = {
  ["name"] = "aardart",
  ["stats"] = {
    ["baseHp"] = 14,
    ["baseAttack"] = 9,
    ["baseDefense"] = 5,
    ["baseSpeed"] = 6,
    ["hpIV"] = 3,
    ["attackIV"] = 4,
    ["defenseIV"] = 2,
    ["speedIV"] = 3
  }
}
```

Each creature is distinguished by a set of base stats, describing the starting point, and a set of individual values, IV, useful when the pokemon levels up — more on this in a future update. You can distinguish the two sets on the basis of the name of each field; consider for instance `baseHp` and `hpIV`.

Starting from the described data, the idea is to have the `Pokemon` class initialize three tables:

- `baseStats`, the starting values

- `stats`, the current values. These are meant to be updated as the game progresses, for instance as the pokemon levels up

- `IVs`, the individual values

Considering the statistics for the first creature again:

```lua
entry = {
  ["name"] = "aardart",
  ["stats"] = {
    ["baseHp"] = 14,
    ["baseAttack"] = 9,
    ["baseDefense"] = 5,
    ["baseSpeed"] = 6,
    ["hpIV"] = 3,
    ["attackIV"] = 4,
    ["defenseIV"] = 2,
    ["speedIV"] = 3
  }
}
```

The idea is to have the data neatly described in the tables as follows:

```lua
baseStats = {
  ["attack"] = 9,
  ["speed"] = 6,
  ["hp"] = 14,
  ["defense"] = 5
}

stats = {
  ["attack"] = 9,
  ["speed"] = 6,
  ["hp"] = 14,
  ["defense"] = 5
}

IVs = {
  ["attack"] = 4,
  ["defense"] = 2,
  ["speed"] = 3,
  ["hp"] = 3
}
```

This approach is considerably different from the one proposed in the course, but I found it more sensible than having each stat described in a different variable.

What's more convenient is that the three tables are built with a for loop, looping through the stats of each entry and using pattern-matching functions available from the `string` library:

- find if the stat contains the word `base`

  ```lua
  local i, j = string.find(k, "base")
  ```

  `string.find` returns the indexes describing the beginning and end of the string matching the pattern. It returns `nil` if no match is found at all.

- if the string matches the pattern, store the associated value in `baseStats` and `stats`. This using as a key the string describing the statistic, in lowercase and without the prefix `base`

  ```lua
  if i then
    local key = string.sub(k, i + 1, -1):lower()
    baseStats[key] = stat
    stats[key] = stat
  end
  ```

  _Please note_: `k` refers to the key `baseHp`, `baseAttack` and so forth.

- if the string doesn't match the `base` pattern, repeat the logic for the string `IV`. In this situation however, store the value in the `IVs` table, and using the string without the `IV` suffix

## In practice

The statistics introduced in the `Pokemon` class are tested out in the game twice. This is rudimentary and ultimately updated in the next update, but it works to show how to use the values.

### Battle

In the `BattleMenuState`, the class receives additional information in its `def` table. This to have a reference to both pokemon and the associated health bars.

```lua
function BattleMenuState:init(def)
  -- previous attributes
  self.playerPokemon = def.playerPokemon
  self.wildPokemon = def.wildPokemon

  self.playerPokemonHealth = def.playerPokemonHealth
  self.wildPokemonHealth = def.wildPokemonHealth
end
```

The `init` function also sets up a boolean to describe which side attacks first. This using the `speed` stat of the two pokemons.

```lua
self.isPlayerFaster = self.playerPokemon.stats.speed >= self.wildPokemon.stats.speed
```

In the selection GUI then, the boolean and the stats are used once more to reduce the health of the two pokemons.

- when selecting the first option — describing the string `fight` — compute the damage as the difference between the attack of one pokemon and the defense of the other

  For instance and for the first

  ```lua
  local damage = math.max(1, self.playerPokemon.stats.attack - self.wildPokemon.stats.defense)
  ```

  `math.max` is to ensure that the side inflicts at least one point damage.

- reduce the health of the side receiving the damage by modifying the health point stats

```lua
self.wildPokemon.stats.hp = math.max(0, self.wildPokemon.stats.hp - damage)
```

`math.max` is to ensure that the health doesn't go into negative values.

- update the associated health bar by modifying its value, and visually the width of its rectangle

```lua
self.wildPokemonHealth:setValue(self.wildPokemon.stats.hp)
self.wildPokemonHealth.fillWidth = self.wildPokemonHealth.width / self.wildPokemonHealth.max * self.wildPokemonHealth.value
```

The operation is repeated for both sides, and in the order described by `self.isPlayerFaster`.

_Please note_: remember to update the code setting up the health bars to use the `hp` of the `stats` and `baseStats` tables in the `value` and `max` fields.

_Please also note_: the code in the battle menu state is modified to animate the health bars through the `Timer` library, and to describe which sides attack with an instance of the `TextBox` GUI. This is however not connected to the use of the stats introduced with this update.

### Heal

When pressing the letter `h` in the play state, the pokemon can finally be healed by setting the stat in the `stats` table to match the value in `baseStats`.

```lua
self.player.pokemon.stats.hp = self.player.pokemon.baseStats.hp
```

## Live demo

I've created the following script to test out the validity of the for loop and pattern-matching functions. For a hard-coded sets of stats, it allows to print out the values in the desired structure.

Feel free to copy-paste in the [live demo environment](https://www.lua.org/cgi-bin/demo) on [lua.org](https://www.lua.org).

```lua
entry = {
  ["stats"] = {
    ["baseHp"] = 14,
    ["baseAttack"] = 9,
    ["baseDefense"] = 5,
    ["baseSpeed"] = 6,
    ["hpIV"] = 3,
    ["attackIV"] = 4,
    ["defenseIV"] = 2,
    ["speedIV"] = 3
  }
}


baseStats = {}
IVs = {}
stats = {}

for k, stat in pairs(entry.stats) do
  local i, j = string.find(k, "base")
  if i then
    local key = string.sub(k, j + 1, -1):lower()
    baseStats[key] = stat
    stats[key] = stat
  else
    local i = string.find(k, "IV")
    if i then
      local key = string.sub(k, 1, i - 1):lower()
      IVs[key] = stat
    end
  end
end

for k, s in pairs(baseStats) do
  print(k .. ": " .. s)
end

print()

for k, s in pairs(stats) do
  print(k .. ": " .. s)
end

print()

for k, s in pairs(IV) do
  print(k .. ": " .. s)
end
--[[
attack: 9
speed: 6
hp: 14
defense: 5

attack: 9
speed: 6
hp: 14
defense: 5

attack: 4
defense: 2
speed: 3
hp: 3
]]
```
