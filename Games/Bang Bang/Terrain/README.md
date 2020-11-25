# Terrain

Here I explore how to create the terrain for the eventual game.

## Normal distribution

The demo works to explore the different arguments the function computing the value for a [normal distribution](https://en.wikipedia.org/wiki/Normal_distribution). This considering a variable mean, standard deviation and multiplying factor (this last one is necessary to scale the measure in the gaming window).

In terms of implementation, the value is computed using the following formula.

```math
f = 1 / (sigma * (2 * math.pi) ^ 0.5) * 2.71828183 ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
```

`mu` describes the mean, `sigma` the standard deviation, `x` the horizontal coordinate. `2.71828183` refers to Euler's number, since it seems that the `math` library provided by Lua doesn't have a constant for this value.

For the purposes of the game, it is important to note the following features:

- the mean `mu` describes the value around which the values are distributed. Initialized at `WINDOW_WIDTH / 2`, it allows to have the peak of the distribution in the very center of the gaming window

- the standard variation `sigma` describes how many observations are collected in the proximity of the mean. Following the [68-95-99.7 rule](https://en.wikipedia.org/wiki/68%E2%80%9395%E2%80%9399.7_rule), 68% of the observations are in the `[mu - sigma, mu + sigma]` range, 95% in the `[mu - sigma * 2, mu + sigma * 2]` and 99.7% in the `[mu - sigma * 3, mu + sigma * 3]` range. This consideration is essential to have the curve flatten itself at either end

_Please note_: the demo draws the distribution with a series of circles, to illustrate the `x` and `y` coordinate of each point. Ultimately, the game will use a `polygon` instead.
