require "globals"
require "player"
require "raycast"
require "controls"
require "util"
require "map"
require "sprite"
require "ai"
require "bullets"
require "decals"

SPRITES = {}
loadMapFromDisk("map01.lua")
setPlayerSpawnPoint()


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

    spriteBatch:clear()
    drawCalls = {}
    castRays()
    renderSprites()
    renderDecals()
    renderBullets()
    sort(drawCalls)    

 --   drawBackground()

    for i = 1, #drawCalls do
        local strip = drawCalls[i]
--        local light = 1 - (strip.dist/20) 
--        if (light < 0) then light = 0 end
--        spriteBatch:setColor(255,255,255,255*light) 
--        print ("Quad: " .. tostring(strip.quad) .. "StripX: " .. tostring(strip.x) .. "StripY: " .. tostring(strip.y) .. "StripSX: " .. tostring(strip.sx) .. "StripSY: " .. tostring(strip.sy))
        spriteBatch:addq(strip.quad,strip.x,strip.y,0,strip.sx,strip.sy)
--        love.graphics.setColor(255,255,255,255*light)
--        love.graphics.drawq(wallsImgs,strip.quad,strip.x,strip.y,0,strip.sx,strip.sy)
    end

    love.graphics.draw(spriteBatch)

--    if (mapProp.displayMap) then drawMiniMap() end
    if (displayDebug) then drawDebug() end
end

function love.update(dt)
    move(player, dt)
    ai(dt)
    manageBullets(dt)
    manageDecals(dt)
end

function love.load()
    wallsImgs = love.graphics.newImage("images.png")
    bgImg = love.graphics.newImage("bg.png")
    local imagesPerHeight = (wallsImgs:getHeight()/mapProp.tileSize)
    local imagesPerWidth = (wallsImgs:getWidth()/mapProp.tileSize)
    spriteBatch = love.graphics.newSpriteBatch( wallsImgs, 9000)
    setQuads(imagesPerHeight,imagesPerWidth)

    makeSpriteMap()

    love.graphics.setColorMode("replace")
    love.graphics.setMode(640,480, false, false)

    love.mouse.setVisible(false)
    love.mouse.setPosition(screenWidth/2,screenHeight/2)
    love.mouse.setGrab(true)
end
