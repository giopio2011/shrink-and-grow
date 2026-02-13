dartpair = Class{}

-- size of the gap between pipes

function dartpair:init()
    -- flag to hold whether this pair has been scored (jumped through)
    self.scored = false
    self.fronty = 0
    self.backy = 0
    self.backup = 0

    -- initialize pipes past the end of the screen
    self.xu = VIRTUAL_WIDTH - 10
    self.xl = self.xu
    self.xb = self.xu
    self.c = 0
    -- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe

    -- instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = dart(),
        ['lower'] = dart(),
        ['front'] = darts(),
        ['back'] = darts()
    }

    -- whether this pipe pair is ready to be removed from the scene
end

function dartpair:update(dt)
    -- remove the pipe from the scene if it's beyond the left edge of the screen,
    -- else move it from right to left
    if self.xl > -10 then
        self.xl = self.xl - 200 * dt
        self.pipes['lower'].x = self.xl
        if self.xl <= 200 then
            self.c = self.c + 1
        end
    else 
        self.xl = self.xb
        self.pipes['lower'].x = self.xl
        self.pipes['lower'].y = math.random(50,250)
        
    end
    if self.c >= 1 then
        if self.xu > -10 then
            self.xu = self.xu - 200 * dt
            self.pipes['upper'].x = self.xu
        else 
            self.xu = self.xb
            self.pipes['upper'].x = self.xu
            self.pipes['upper'].y = math.random(50,250)
        end
    end
    if self.fronty < VIRTUAL_HEIGHT then
        self.fronty = self.fronty + 200 * dt
        self.pipes['front'].y = self.fronty 
    else
        self.fronty = self.backup
        self.pipes['front'].y = self.fronty
        self.pipes['front'].x = math.random(200,400)
    end
    if self.backy < VIRTUAL_HEIGHT then
        self.backy = self.backy + 200 * dt
        self.pipes['back'].y = self.backy
    else
        self.backy = self.backup
        self.pipes['back'].y = self.backy
        self.pipes['back'].x = math.random(0,200)
    end
end

function dartpair:render()
    self.pipes['lower']:render()
    self.pipes['upper']:render()
    self.pipes['front']:render()
    self.pipes['back']:render()
end