Using the `timer` module from the **knife** library, chaining a set of operations becomes much easier. Following the action described by the `Timer` object, include a `:finish()` function. This function accepts an anonymous function describing what to do when the previous event finished.

```lua
Timer.tween(RATE, {

}):finish(function()
  Timer.tween(RATE, {
  [bird] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, y = VIRTUAL_HEIGHT - BIRD_HEIGHT}
  }) end)
```

The only complication is that the syntax becomes harder to parse, especially nesting a series of functions.

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

The **knife** library provides a `chain` module to simplify this structure.