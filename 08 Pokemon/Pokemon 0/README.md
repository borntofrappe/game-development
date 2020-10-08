Create a start state with a title and a looping animation.

## Text

The idea is to show introductory text in the form of a title and a brief instruction on how to continue.

```lua
function StartState:render()
  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Pokemon!", 0, VIRTUAL_HEIGHT / 4 - 24, VIRTUAL_WIDTH, "center")
  love.graphics.setFont(gFonts["small"])
  love.graphics.printf("Press enter", 0, VIRTUAL_HEIGHT / 4 + 24, VIRTUAL_WIDTH, "center")

end
```

The instruction is pointless, as the state stack only considers the start state, but it becomes pertinent as the game is updated to consider multiple states.

## Pokemon

Below the text, the idea is to then show one sprite from the `pokemon` folder, and specifically the `-front` variant for each specimen. In `constants.lua`, I decided to initialize a variable to keep track of the available pokemons.

```lua
POKEDEX = {"aardart", "agnite", "anoleaf", "bamboon", "cardiwing"}
```

The idea is to have the start state pick at random from the available set.

In `Dependencies.lua` then, the table describing the raster images is built to have each pokemon nested in a table.

```lua
gTextures = {
  ["pokemon"] = {
    -- pokemons
  }
}
```

Each pokemon then describes yet another table, with the front and back variant of the matching sprite.

```lua
gTextures = {
  ["pokemon"] = {
    ["aardart"] = {
      ["back"] = love.graphics.newImage(""),
      ["front"] = love.graphics.newImage("")
    },
    -- other pokemons
  }
}
```

This structure allows the start state to pick a pokemon from the `POKEDEX` constants, and use the graphics in the `gTexture` function accessing the desired variant.

```lua
function StartState:init()
  self.pokemon = {
      ["sprite"] = POKEDEX[math.random(#POKEDEX)]
  }
end

function StartState:render()
  love.graphics.draw(
    gTextures["pokemon"][self.pokemon.sprite]["front"],
    x,
    y
  )
end
```

## Timer

To move the sprite from side to side, the update re-introduces the `timer` library, first used in the game _Match Three_.

The idea is to animate the sprite to change in its `x` coordinate, and it is therefore necessary to have a variable keep track of this position.

```lua
function StartState:init()
  self.pokemon = {
      ["sprite"] = POKEDEX[math.random(#POKEDEX)],
      x = VIRTUAL_WIDTH / 2 - POKEMON_WIDTH / 2,
      y = VIRTUAL_WIDTH / 2 - POKEMON_WIDTH / 2,
  }
end
```

The variable is updated with the timer library, and used in the logic of the render function.

```lua
function StartState:render()
  love.graphics.draw(
    gTextures["pokemon"][self.pokemon.sprite]["front"],
    self.pokemon.x,
    self.pokemon.y
  )
end
```

In terms of how the variable is updated at an interval, and with the following structure:

- move the sprite from the center of the screen to the left of the window, out of sight

- reposition the sprite to the right side of the window, again out of sight

- update the sprite to describe a different pokemon

- move the updated sprite to the center of the screen

- repeat

This logic is nested in `Timer.every`, to repeat the logic at an interval.

```lua
Timer.every(
  4,
  function()
    -- animation
  end
)
```

To animate the position, use `Timer.tween`, modifying the `x` field of `self.pokemon`.

```lua
Timer.tween(
  0.25,
  {
    [self.pokemon] = {x = - POKEMON_WIDTH}
  }
)
```

To chain the operations one after the other then, benefit from the `:finish` function.

```lua
Timer.tween():finish(function()
  -- do something
end)
```

This is available on the `Timer` functions and is called as the animation is complete.
