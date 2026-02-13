wall = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function wall:init( width, height)
    self.width = width
    self.height = height
    self.x = VIRTUAL_WIDTH/2-2
    self.y = VIRTUAL_HEIGHT/2-10
    self.yx = VIRTUAL_HEIGHT/2-10
    self.xx = self.x
    self.heigh = height
    self.minh = 4
    self.minw = 4
end

function wall:collidespipe(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT  then
            return true
        end
    end

    return false
end
function wall:collidesdarts(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + 10 then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + 4  then
            return true
        end
    end

    return false
end
function wall:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + 4 then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + 10  then
            return true
        end
    end

end
function wall:update(dt)
    if self.height < self.minh then
        self.height = self.minh
        self.y = self.yx
    end
    if self.width < self.minw then
        self.width = self.minw
        self.x = self.xx
    end
    if self.y <= 0 + self.height then
        self.y = 0
    elseif self.y >= VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT
    end
    if self.x <= 0  + self.width then 
        self.x = 0
    elseif self.x >= VIRTUAL_WIDTH - self.width then
        self.x = VIRTUAL_WIDTH
    end
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function wall:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.rectangle('fill', self.x,self.y,4,4)
end