# Pokemon 6

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Pokemon — Final`.

## Goal

The goal of this update is to show the battle state as the player walks in the bottom section of the level. This requires a few modifications to the existing codebase, but it's focused on the `BattleState` class.

## StartState

This is but a minor tweak to the version proposed in the course. The idea is to have the player use the pokemon from the selection screen, from the `StartState` if a particular key is pressed.

```lua
local pokemon = POKEDEX[math.random(#POKEDEX)]
if love.keyboard.isDown("p") then
  pokemon = self.pokemon.sprite
end
gStateStack:push(PlayState(pokemon))
```

## PlayState

`PlayState` initializes the player with an additional field, and in order to describe the pokemon for the player.

```lua
function PlayState:init(pokemon)
  self.player =
    Player(
    {
      -- previous attributes
      pokemon = pokemon
    }
  )
end
```

## Player

The `Player` class receives the pokemon in its `init` function.

```lua
function Player:init(def)
  self.pokemon = def.pokemon
end
```

The value is however used in te walking state, as the position of the player is updated.

### PlayerWalkingState

In the video, the lecturer introduces the battle state as the player starts walking, but I found it easier to consider the encounter following the `Timer.tween` animation.

Pending a boolean, the state is invoked through the `gStateStack`, passing the instance of the player to have the battle state work with the player's pokemon.

```lua
local foundEncounter = self.player.row > ROWS - ROWS_GRASS and math.random(10) == 1

if foundEncounter then
   gStateStack:push(BattleState(self.player))
end
```

_Please note_: the battle state is pushed to the stack in between two `FadeState`, to repeat the same transition introducing the play state.

## BattleState

_Please note_: it is highly likely the state will change in future updates, as the code becomes more modular and introduces GUIs and other useful classes.

The idea is to show two pokemon, one for the player and one for the wild encounter. The player variant is retrieved from the `player` instance.

```lua
function BattleState:init(player)
  self.player = player

  self.playerPokemon = {
    ["sprite"] = self.player.pokemon
  }
end
```

The wild counterpart is picked at random from the available set.

```lua
function BattleState:init(player)
  self.wildPokemon = {
    ["sprite"] = POKEDEX[math.random(#POKEDEX)],
  }
end
```

Both are defined through a table, in order to also define their coordinates through specific variables. For instance and for the player's specimen.

```lua
self.playerPokemon = {
  ["sprite"] = self.player.pokemon,
  x = -POKEMON_WIDTH * 2,
  y = VIRTUAL_HEIGHT - 56 - 4 - POKEMON_HEIGHT
}
```

The idea is to ultimately animate the horizontal coordinate to have the critters slide from the opposing sides of the window. For instance, and again for the player's creature.

```lua
Timer.tween(
  1,
  {
    [self.playerPokemon] = {x = 8 + POKEMON_WIDTH / 2},
  }
)
```

Past the `init` function, the `update` method updates the timer object and allows to move back to the play state by pressing the escape key. This is to show how the play state is still in the stack, and in its previous condition.

```lua
function BattleState:update(dt)
  Timer.update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateStack:pop()
  end
end
```

It is in the logic of the `render` function then, that the sprites of the two pokemon are rendered, above two ellipses.

```lua
love.graphics.setColor(0.25, 0.75, 0.5)
  love.graphics.ellipse(
    "fill",
    self.playerPokemon.x + POKEMON_WIDTH / 2,
    self.playerPokemon.y + POKEMON_HEIGHT,
    POKEMON_WIDTH,
    16
  )

love.graphics.setColor(1, 1, 1)
love.graphics.draw(
    gTextures["pokemon"][self.playerPokemon.sprite]["back"],
    self.playerPokemon.x,
    self.playerPokemon.y
)
```

Above it all, a rectangle similar to the one described in the dialogue state shows the name of the wild pokemon.

```lua
love.graphics.setFont(gFonts["small"])
love.graphics.setColor(1, 1, 1)
love.graphics.print("A wild " .. self.wildPokemon.sprite .. "appeared!", 8, VIRTUAL_HEIGHT - 56)
```
