
-- https://github.com/Ulydev/push
push = require 'push'
level = 1
--  the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'wall'
require 'Pipe'
require 'PipePair'
require 'dart'
require 'darts'
require 'dartpair'





-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288
scrolling = true

levelnum = 1
score = 0
gamestate = "title"
timegap = 2
--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')
    pipePairs = {}
    timer = 0
    lastY = -PIPE_HEIGHT + math.random(80) + 20
    -- set the title of our application window
    love.window.setTitle('shrink and grow')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    love.keyboard.keysPressed = {}
    image = love.graphics.newImage('pause3.png')
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules
    player = wall( 5, 20)
    darts = dartpair()
end
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gamestate == "title" then
        player.y = VIRTUAL_HEIGHT/2
        player.x = VIRTUAL_WIDTH/2
        player.height = 20
        player.width = 5
        pipePairs = {}
        darts.xl = VIRTUAL_WIDTH-10
        darts.xu = VIRTUAL_WIDTH-10
        darts.pipes['lower'].y = math.random(50,250)
        darts.pipes['upper'].y = math.random(50,250)
        darts.pipes['back'].x = math.random(0,200)
        darts.pipes['front'].x = math.random(200,400)
        darts.fronty = 0
        darts.backy = 0
        score = 0
        win = false
        level = 1
        levelnum = 1
        player.minh = 4
        player.minw = 4
    end
    if gamestate == "play" then
        if scrolling == true then
            if love.keyboard.isDown('w') then
                player.height = player.height + 2
                player.y = player.y - 1
            elseif love.keyboard.isDown('s') then
                player.height = player.height - 2
                player.y = player.y + 1 
            elseif love.keyboard.isDown('d') then
                player.width = player.width + 2
                player.x = player.x -1
            elseif love.keyboard.isDown('a') then
                player.width = player.width - 2
                player.x = player.x + 1
            elseif love.keyboard.isDown('up') then
                player.y = player.y - 2
                player.yx = player.yx - 2
            elseif love.keyboard.isDown('down') then
                player.y = player.y + 2
                player.yx = player.yx + 2
            elseif love.keyboard.isDown('right') then
                player.x = player.x + 2
                player.xx = player.xx + 2
            elseif love.keyboard.isDown('left') then
                player.x = player.x - 2
                player.xx = player.xx - 2
            end
            timer = timer + dt
            -- spawn a new pipe pair every second and a half
            
                
            if timer > 4 - levelnum then
                -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
                -- no higher than 10 pixels below the top edge of the screen,
                -- and no lower than a gap length (90 pixels) from the bottom
                local y = math.max(-PIPE_HEIGHT + 10, 
                    math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
                lastY = y

                -- add a new pipe pair at the end of the screen at our new Y
                table.insert(pipePairs, PipePair(y))

                -- reset timer
                timer = 0
            end

            for k, pair in pairs(pipePairs) do
                if pair then
                    if not pair.scored then
                        if pair.x + PIPE_WIDTH < player.x then
                            score = score + 1 * math.floor((player.height /(4+ levelnum)  + player.width/(4+levelnum)) / levelnum)
                            pair.scored = true
                        end
                    end
                
                end
            
                pair:update(dt)
            end
            if score == 20 and levelnum == 1 then
                level = level - 0.1
                levelnum = levelnum + 1
                timegap = timegap - 0.2
                player.minh = player.minh + 2
                player.minw = player.minw + 2
                
            elseif score == 40 and levelnum == 2 then
                level = level - 0.1
                levelnum = levelnum + 1
                timegap = timegap - 0.2
                player.minh = player.minh + 2
                player.minw = player.minw + 2
                
            elseif score == 60 and levelnum == 3 then
                level = level - 0.1
                levelnum = levelnum + 1
                timegap = timegap - 0.2
                player.minh = player.minh + 2
                player.minw = player.minw + 2
                
            elseif score == 80 and levelnum == 4 then
                level = level - 0.1
                levelnum = levelnum + 1
                timegap = timegap - 0.2
                player.minh = player.minh + 2
                player.minw = player.minw + 2
                
            elseif score >= 100 then
                gamestate = "win"
            end
            
            for k, pair in pairs(pipePairs) do
                if pair.remove then
                    table.remove(pipePairs, k)
                end
            end
            for k, pair in pairs(pipePairs) do
                for l, pipe in pairs(pair.pipes) do
                    if pipe then

                        if player:collidespipe(pipe) then
                            gamestate = 'gameover'
                        end
                    end
                end
            end
            if player:collidesdarts(darts.pipes['lower']) then
                gamestate = 'gameover'
            elseif player:collidesdarts(darts.pipes['upper']) then
                gamestate = 'gameover'
            elseif player:collides(darts.pipes['front']) then
                gamestate = 'gameover'
            elseif player:collides(darts.pipes['back']) then
                gamestate = 'gameover'
            end
            darts:update(dt)
            player:update(dt)
        end
                
        
    end
end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    -- `key` will be whatever key this callback detected as pressed
    if key == 'escape' then
        -- the function LÖVE2D uses to quit the application
        love.event.quit()
    -- if we press enter during either the start or serve phase, it should
    -- transition to the next appropriate state
    elseif key == 'p' then
        scrolling = false

    elseif key == 'h' then
        if gamestate =="title" then
            gamestate = "play"
        elseif gamestate =="gameover" then
            gamestate = "title"
        elseif gamestate=="win" then
            gamestate = "title"
    
        elseif gamestate == "play" then
            gamestate = "help"  
        elseif gamestate == "help" then
            gamestate = "play"
        end
    elseif key == 'b' then
        scrolling = true
    end



end
 

function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')
    if gamestate == 'title' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to shrink and grow!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press h to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
        player:render()
    end
    if gamestate == 'play' then
        love.graphics.clear(40/255, 45/255, 52/255, 255/255)
        for k, pair in pairs(pipePairs) do
            pair:render()
        end
        
        displayScore()
        
        darts:render()        
        player:render()
        if scrolling ==  false then
            love.graphics.draw(image,VIRTUAL_WIDTH/2-60,VIRTUAL_HEIGHT/2-60)
        end
    end
    if gamestate == "help" then
        love.graphics.setFont(largeFont)
        love.graphics.printf('press right to go right' ,0,VIRTUAL_HEIGHT/2+16*4,VIRTUAL_WIDTH,'center')
        love.graphics.printf('press left to go left' ,0,VIRTUAL_HEIGHT/2+16*3,VIRTUAL_WIDTH,'center')
        love.graphics.printf('press down to go down' ,0,VIRTUAL_HEIGHT/2+16*2,VIRTUAL_WIDTH,'center')
        love.graphics.printf('press up to go up' ,0,VIRTUAL_HEIGHT/2+16,VIRTUAL_WIDTH,'center')
        love.graphics.printf('press d to get width ' ,0,VIRTUAL_HEIGHT/2-16,VIRTUAL_WIDTH,'center')
        love.graphics.printf('press a to get less width ' ,0,VIRTUAL_HEIGHT/2-16*2,VIRTUAL_WIDTH,'center')
        love.graphics.printf('press w to get height' ,0,VIRTUAL_HEIGHT/2-16 *3,VIRTUAL_WIDTH,'center')
        love.graphics.printf('press s to get less height' ,0,VIRTUAL_HEIGHT/2-16*4,VIRTUAL_WIDTH,'center')
        love.graphics.printf('hint: the larger you are the more points you get' ,0,VIRTUAL_HEIGHT/2- 16*5,VIRTUAL_WIDTH,'center')
        love.graphics.printf('get 100 points and you win!' ,0,VIRTUAL_HEIGHT/2+16*5,VIRTUAL_WIDTH,'center')
    end

    if gamestate == 'gameover' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Press h to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end
    if gamestate=="win" then
        love.graphics.setFont(largeFont)
        love.graphics.printf('you won!' ,0,VIRTUAL_HEIGHT/2,VIRTUAL_WIDTH,'center')
    end
    
    -- end our drawing to push
    push:apply('end')
end
function displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(score), VIRTUAL_WIDTH / 2,
    VIRTUAL_HEIGHT / 3)
end


