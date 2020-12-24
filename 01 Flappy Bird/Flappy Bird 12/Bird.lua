Bird = Class{}

GRAVITY = 5
MERCY = 5

function Bird:init()
    self.image = love.graphics.newImage('res/graphics/bird.png')
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
        self.dy = -2
    end

    if love.mouse.coor['x'] > self.x - MERCY and love.mouse.coor['x'] < self.x + self.width + MERCY then
        if love.mouse.coor['y'] > self.y - MERCY and love.mouse.coor['y'] < self.y + self.height + MERCY then
            sounds['jump']:play()
            self.dy = -2
        end
    end

end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end