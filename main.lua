require "globals"
require "player"
require "raycast"
require "controls"
require "util"
require "map"
require "sprite"

loadMapFromDisk("map01.lua")

SPRITES = {}
SPRITES[1] = 
    {
        x = 5,
        y = 5,
        img = 0,
        visible = false
    }

SPRITES[2] = 
    {
        x = 4,
        y = 5,
        img = 1,
        visible = false
    }

SPRITES[3] = 
    {
        x = 4,
        y = 4,
        img = 2,
        visible = false
    }

SPRITES[4] = 
    {
        x = 5,
        y = 4,
        img = 3,
        visible = false
    }

SPRITES[5] = 
    {
        x = 6,
        y = 4,
        img = 4,
        visible = false
    }

function gameCycle()
    local dt = love.timer.getDelta()
    move(dt)

    local cycleDelay = gameCycleDelay
    if (dt > cycleDelay) then
        cycleDelay = math.max(1, cycleDelay - (dt - cycleDelay))
    end
end


function love.draw()
    love.graphics.setColor(50,50,50)
    love.graphics.rectangle( "fill",
     0,screenHeight/2,screenWidth,screenHeight/2
    )

--    love.graphics.setColor(0, 0, 0)
 --   love.graphics.rectangle( "fill",
  --   0,0,screenWidth,screenHeight/2
   -- )
    spriteBatch:clear()
    drawCalls = {}
    castRays()
    renderSprites()
    sort(drawCalls)    

 --   drawBackground()

--    love.graphics.setColorMode("modulate")
    for i = 1, #drawCalls do
        local strip = drawCalls[i]
--        local light = 1 - (strip.dist/20) 
--        if (light < 0) then light = 0 end
--        spriteBatch:setColor(255,255,255,255*light) 
        spriteBatch:addq(strip.quad,strip.x,strip.y,0,strip.sx,strip.sy)
--        love.graphics.setColor(255,255,255,255*light)
--        love.graphics.drawq(wallsImgs,strip.quad,strip.x,strip.y,0,strip.sx,strip.sy)
    end

    love.graphics.draw(spriteBatch)
--    if (mapProp.displayMap) then drawMiniMap() end
    if (displayDebug) then drawDebug() end
end

function love.update(dt)
    move(dt)
end

function love.load()
    wallsImgs = love.graphics.newImage("images.png")
    bgImg = love.graphics.newImage("bg.png")
    local numberOfImages = (wallsImgs:getHeight()/mapProp.tileSize)
    spriteBatch = love.graphics.newSpriteBatch( wallsImgs, 9000)
    setQuads(numberOfImages)

    makeSpriteMap()

    love.graphics.setColorMode("replace")
    love.graphics.setMode(640,480, false, false)

    love.mouse.setVisible(false)
    love.mouse.setPosition(screenWidth/2,screenHeight/2)
    love.mouse.setGrab(true)
end
