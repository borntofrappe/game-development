Here you add audio.

**requires a res folder with push.lua, font.ttf, class.lua and the sounds folder**

## Audio

Including audio is a simple matter of initializing variables in the `load()` function and later access them where needed.

In the `load()` function, initialize the audio files in a table.

```lua
sounds = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
}
```

`love.audio.newSource()` accepts as argument the path and the type of the audio file. The type refers to the way the sound is imported in the application, and by setting it to `static`, it means that the audio files are included upfront in the `load()` function

Once the table is created, you can access its values either through dot or bracket notation.

```lua
sounds.paddle_hit
sounds['paddle_hit']
```

And you can play the audio using the `play` method:

```lua
sounds['paddle_hit']:play()
```

Once you know how it is a matter of placing the audio files where needed:

- when the ball hits a paddle;

- when the ball hits a wall;

- when a point is scored

- when the victory state is reached
