# Flappy Bird 11 - Sound

A few sound files are included for:

- the soundtrack, an audio file set to loop;

- the bird 'jumping';

- a point being scored;

- a wall being hit.

There are a few changes from implementing audio in Pong, but the previous considerations hold true.

- include the audio files in a table;

```lua
sounds = {
  ['jump'] = love.audio.newSource('jump.wav', 'static'),
  ['hit'] = love.audio.newSource('hit.wav', 'static'),
  ['lose'] = love.audio.newSource('lose.wav', 'static'),
  ['score'] = love.audio.newSource('score.wav', 'static'),
  -- audio set to be repeated
  ['soundtrack'] = love.audio.newSource('soundtrack.mp3', 'static')
}
```

- play them through the `:play` function.

```lua
sounds['jump']:play()
```

In order to have the soundtrack play constantly use the `:setLooping()` function, passing `true`

```lua
sounds['soundtrack']:setLooping(true)
sounds['soundtrack']:play()
```

To achieve a more subtle sound for the losing condition, and perhaps only when hitting a wall, you can also use audio files at the same time (layering).

```lua
sounds['lose']:play()
sounds['hit']:play()
```

Decided to update the structure of the `Resource` folder, as to nicely frame each different asset.
