dart = Class{}

function dart:init()
    self.height = 4
    self.width = 10
    self.y = math.random(50,250)
    self.x = VIRTUAL_WIDTH - 10
end

function dart:update()
    self.x = self.x - 1
end

function dart:render()
    love.graphics.setColor(love.math.colorFromBytes(math.random(0,225), math.random(0,225), math.random(0,225)))
    love.graphics.rectangle('fill', self.x,self.y,self.width,self.height)
end