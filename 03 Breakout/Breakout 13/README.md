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

## Update

The presence of the soundbyte `no-select` leads me to revise the way the arrows are rendered. This is most likely covered in the video, but I forgot to repeat the feature when recreating the game. The idea is to have the arrow semi-transparent if the paddle describes the first/last choice.

In the previuos version, the arrows are always representative of a choice. If you press the left arrow on the first choice, you'd obtain the last choice. Vice versa if pressing the right arrow for the last choice,

```lua
if love.keyboard.waspressed('right') then
  self.paddle.color = self.paddle.color == 4 and 1 or self.paddle.color + 1
  gSounds['select']:play()
end

if love.keyboard.waspressed('left') then
  self.paddle.color = self.paddle.color == 1 and 4 or self.paddle.color - 1
  gSounds['select']:play()
end
```

With this approach, however, you remove the option. The only way you reach the last option is by pressing the right arrow. The only way you reach the first is with the left. For one of the two sides for instance.

```lua
if love.keyboard.waspressed('right') then
  if self.paddle.color == 4 then
    gSounds['no-select']:play()
  else
    self.paddle.color = self.paddle.color + 1
    gSounds['select']:play()
  end
end
```

You can update the color using `math.min`, or `math.max`, but with the explicit loop you also specify the sound to play the dedicated audio.

The audio provides a hint, but so the way the arrows are rendered. Using the current color, the idea is to have the arrow semi-transparent by modifying the color with `setColor`. The fourth argument — alpha — affects images similarly to shapes.

```lua

if self.paddle.color == 4 then
  love.graphics.setColor(1, 1, 1, 0.5)
  -- right arrow
end
```
