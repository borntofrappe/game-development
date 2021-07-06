# Chain 1

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

Using the `timer` module, chaining a set of operations becomes much easier. Following the action described by the `Timer` object, include a `:finish()` function. This function accepts an anonymous function which is called when the previous operation comes to an end.

```lua
Timer.tween(RATE, {

}):finish(function()
  Timer.tween(RATE, {
  [bird] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, y = VIRTUAL_HEIGHT - BIRD_HEIGHT}
  }) end)
```

The only complication is that the syntax becomes harder to parse, especially when nesting multiple functions.

```lua
Timer.tween(RATE, {

}):finish(function()
  Timer.tween(RATE, {

  }):finish(function()
    Timer.tween(RATE, {

    }):finish(function()
      Timer.tween(RATE, {

      })
    end)
  end)
end)
```

While beyond the scope of the course, note that the `knife` library provides a `chain` module which potentially simplify the sequence.
