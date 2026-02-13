darts = Class{}

function darts:init()
    self.x = math.random(0,400)
    self.y = 0
end
function darts:render()
    love.graphics.setColor(love.math.colorFromBytes(math.random(0,225), math.random(0,225), math.random(0,225)))
    love.graphics.rectangle('fill',self.x,self.y,4,10)
end