Add sounds.

> assumes a _res_ folder with the necessary dependencies and assets

Audio files are included exactly like in the game pong.

In `main.lua` add a table matching the keys to the respective paths.

```lua
sounds = {
  ['countdown'] = love.audio.newSource('res/sounds/countdown.wav', 'static'),
  ['hit'] = love.audio.newSource('res/sounds/hit.wav', 'static'),
  ['jump'] = love.audio.newSource('res/sounds/jump.wav', 'static'),
  ['lose'] = love.audio.newSource('res/sounds/lose.wav', 'static'),
  ['score'] = love.audio.newSource('res/sounds/score.wav', 'static'),
  ['soundtrack'] = love.audio.newSource('res/sounds/soundtrack.wav', 'static')
}
```

However, the course introduces two concepts for a more refined approach.

## Soundtrack

Play the audio behind `soundtrack` on a loop.

```lua
sounds['soundtrack']:setLooping(true)
sounds['soundtrack']:play()
```

## Layering

When the bird hits the a wall, play the `lose` and `hit` sounds at the same time.

```lua
sounds['lose']:play()
sounds['hit']:play()
```
