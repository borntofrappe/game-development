MAZE_DIMENSION = 14
CELL_SIZE = 30
MAZE_SIZE = CELL_SIZE * MAZE_DIMENSION

WINDOW_PADDING = 10
WINDOW_MARGIN_TOP = 28

WINDOW_WIDTH = MAZE_SIZE + WINDOW_PADDING * 2
WINDOW_HEIGHT = MAZE_SIZE + WINDOW_MARGIN_TOP + WINDOW_PADDING * 2

UPDATE_INTERVAL = 0.5
UPDATE_TWEEN = 0.3

PROGRESS_MAX = 100
PROGRESS_INITIAL = 25
PROGRESS_STEPS = 5

PARTICLE_SYSTEM_DUST_PARTICLES = 50
PARTICLE_SYSTEM_DUST_BUFFER = PARTICLE_SYSTEM_DUST_PARTICLES * PROGRESS_STEPS
PARTICLE_SYSTEM_DUST_LIFETIME_MIN = 0.2
PARTICLE_SYSTEM_DUST_LIFETIME_MAX = 0.4
PARTICLE_SYSTEM_DUST_LINEAR_ACCELERATION = {-60, 60}
PARTICLE_SYSTEM_DUST_RADIAL_ACCELERATION = {20, 100}

PARTICLE_SYSTEM_DEBRIS_PARTICLES = 10
PARTICLE_SYSTEM_DEBRIS_BUFFER = PARTICLE_SYSTEM_DEBRIS_PARTICLES
PARTICLE_SYSTEM_DEBRIS_LIFETIME_MIN = 0.25
PARTICLE_SYSTEM_DEBRIS_LIFETIME_MAX = 0.55
PARTICLE_SYSTEM_DEBRIS_LINEAR_ACCELERATION = {-80, 80}
PARTICLE_SYSTEM_DEBRIS_RADIAL_ACCELERATION = {100, 200}
