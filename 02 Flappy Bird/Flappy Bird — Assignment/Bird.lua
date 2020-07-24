Bird = Class{}

GRAVITY = 7
JUMP = -3
MERCY = 5

function Bird:init()
    self.image = love.graphics.newImage('res/graphics/fish.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)
    if self.x + self.width < pipe.x + MERCY or self.x > pipe.x + pipe.width - MERCY then
        return false
    end

    if self.y + self.height < pipe.y + MERCY or self.y > pipe.y + pipe.height - MERCY then
        return false
    end

    return true
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy

    if love.keyboard.waspressed('space') then
        sounds['jump']:play()
        self.dy = JUMP
    end

    if love.mouse.waspressed then
        sounds['jump']:play()
        self.dy = JUMP
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end