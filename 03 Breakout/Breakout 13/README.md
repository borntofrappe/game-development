Allow to choose a paddle.

## Arrows

The graphics folder provide a helpul asset in _arrows.png_. The idea is to create the quads with a method similar to the one described for the hearts.

```lua
gFrames = {
  -- previous frames,
  ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24)
}
```

And to then render the arrows at either side of the paddle.

## PaddleSelect

The new state is introduced between the start and serve state. The idea is to render some text, and only the paddle. By pressing the arrow keys then, the idea is to change the color of the paddle looping through the possible four variants.

It's important to note that the table start with a key of `1`, so accessing the `0`th element would result in an error.
