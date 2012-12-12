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
require "mapgenerator"
require "roomgenerator"
require "hud"

SPRITES = {}
--loadMapFromDisk("map01.lua")
--setPlayerSpawnPoint()

generateMap()


function gameCycle()
    local dt = love.timer.getDelta()
    move(dt)

    local cycleDelay = gameCycleDelay
    if (dt > cycleDelay) then
        cycleDelay = math.max(1, cycleDelay - (dt - cycleDelay))
    end
end


function love.draw()
    love.graphics.setColor(100,100,100)
    love.graphics.rectangle( "fill",
     0,screenHeight/2,screenWidth,screenHeight/2
    )
    love.graphics.setColor(200,200,200)
    love.graphics.rectangle( "fill",
     0,0,screenWidth,screenHeight/2
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
        if (strip.hit) then
            spriteBatch:setColor( 255, 0, 0, 255)
        end
--        spriteBatch:setColor( 255/strip.dist, 255/strip.dist, 255/strip.dist, 255)
        if (strip.quad) then
            spriteBatch:addq(strip.quad,strip.x,strip.y,0,strip.sx,strip.sy)
        end
        spriteBatch:setColor()
--        love.graphics.setColor(255,255,255,255*light)
--        love.graphics.drawq(wallsImgs,strip.quad,strip.x,strip.y,0,strip.sx,strip.sy)
    end

    spriteBatch:setColor( 255, 255, 255, 255)
    love.graphics.draw(spriteBatch)

    if (player.hit) then
        player.hitDecay = player.hitDecay - 1
        love.graphics.setColor(255,255,255,55)
        love.graphics.draw(hitImg,0,0,0,15,12)
        if (player.hitDecay < 0) then
            player.hitDecay = 10
            player.hit = false
        end
    end

--    if (mapProp.displayMap) then drawMiniMap() end
    if (displayDebug) then drawDebug() end
    drawHud()
    drawMiniMap()
end

function love.update(dt)
    move(player, dt)
    ai(dt)
    manageBullets(dt)
    manageDecals(dt)

    if (areEnemiesDead()) then
        mapGenManagement(dt)
    end
end

function love.load()
    wallsImgs = love.graphics.newImage("images.png")
--    bgImg = love.graphics.newImage("bg.png")
    hitImg = love.graphics.newImage("hit.png")
    local imagesPerHeight = (wallsImgs:getHeight()/mapProp.tileSize)
    local imagesPerWidth = (wallsImgs:getWidth()/mapProp.tileSize)
    spriteBatch = love.graphics.newSpriteBatch( wallsImgs, 9000)
    setQuads(imagesPerHeight,imagesPerWidth)

    makeSpriteMap()
    loadHud()
    
    soundShoot = love.audio.newSource("shoot.wav", "static")
    soundHit1 = love.audio.newSource("hit1.wav", "static")
--    music1 = love.audio.newSource("track1.ogg")
--    love.audio.play(music1)
--    music1:setLooping(true)

    love.graphics.setColorMode("modulate")
    love.graphics.setMode(640,480, false, false)

    love.mouse.setVisible(false)
    love.mouse.setPosition(screenWidth/2,screenHeight/2)
    love.mouse.setGrab(true)
end
