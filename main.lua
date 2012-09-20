require "globals"
require "player"
require "raycast"
require "controls"
require "util"
require "map"

loadMapFromDisk("map01.lua")

SPRITES = {
    x=5,
    y=5,
    visible=false
    }
spriteMap = {}

function makeSpriteMap()
    for i=1,#map do
        spriteMap[i] = 0
    end
    spriteMap[(indexFromCoordinates(SPRITES.x,SPRITES.y))] = 1
end

makeSpriteMap()

drawCalls = {}
QUADS = {}
SPRITEQUAD = {}

function gameCycle()
    local dt = love.timer.getDelta()
    move(dt)

    local cycleDelay = gameCycleDelay
    if (dt > cycleDelay) then
        cycleDelay = math.max(1, cycleDelay - (dt - cycleDelay))
    end
end

function renderSprites()
    local dx = SPRITES.x + 0.5 - player.x
    local dy = SPRITES.y + 0.5 - player.y

    local dist = math.sqrt(dx*dx + dy*dy)
    local spriteAngle = math.atan2(dy, dx) - player.rot

    local spriteSize = viewDist / (math.cos(spriteAngle) * dist) 

    local spriteX = math.tan(spriteAngle) * viewDist
    local top = (screenHeight - spriteSize)/2
    local left = (screenWidth/2 + spriteX - spriteSize/2)
    local dbx = SPRITES.x - player.x
    local dby = SPRITES.y - player.y
    local blockDist = dbx*dbx + dby*dby
    local z = -math.floor(dist*10000)
    if (SPRITES.visible) then
        --love.graphics.drawq(harrisImg,SPRITEQUAD[0],left,top,0,spriteSize/mapProp.tileSize,spriteSize/mapProp.tileSize)
        drawCalls[#drawCalls+1] = 
        {
            z = z,
            x = left,
            y = top,
            dist = dist,
            sx = spriteSize / mapProp.tileSize,
            sy = spriteSize / 64,
            quad = SPRITEQUAD[0]
        } 
        SPRITES.visible = false
    end
end

function love.draw()
    love.graphics.setColor(50,50,50)
    love.graphics.rectangle( "fill",
     0,screenHeight/2,screenWidth,screenHeight/2
    )

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle( "fill",
     0,0,screenWidth,screenHeight/2
    )
    spriteBatch:clear()
    drawCalls = {}
    castRays()
    renderSprites()
    sort(drawCalls)    

    for i = 1, #drawCalls do
        strip = drawCalls[i]
        spriteBatch:addq(strip.quad,strip.x,strip.y,0,strip.sx,strip.sy)
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
    local numberOfImages = (wallsImgs:getHeight()/mapProp.tileSize)
   
    SPRITEQUAD[0] = love.graphics.newQuad(mapProp.tileSize, 0, mapProp.tileSize, mapProp.tileSize, -1+2*mapProp.tileSize, numberOfImages*mapProp.tileSize)
    spriteBatch = love.graphics.newSpriteBatch( wallsImgs, 9000)

    harrisImg = love.graphics.newImage("harrison.png")
    harrisonBatch = love.graphics.newSpriteBatch( harrisImg, 9)

    love.graphics.setColorMode("replace")
    love.graphics.setMode(640,480, false, false)
    setQuads(numberOfImages)
    love.mouse.setVisible(false)
    love.mouse.setPosition(screenWidth/2,screenHeight/2)
    love.mouse.setGrab(true)
end
