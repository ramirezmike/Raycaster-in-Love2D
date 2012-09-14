require "globals"
require "raycast"
require "controls"
require "player"
require "util"
require "map"

loadMapFromDisk("map01.lua")

QUADS = {}

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
   
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle( "fill",
        0,0,screenWidth,screenHeight/2
    )

    castRays()
    if (mapProp.displayMap) then drawMiniMap() end
    if (displayDebug) then drawDebug() end
end

function love.update(dt)
    move(dt)
end

function love.load()
    wallsImgs = love.graphics.newImage("walls.png")
    local numberOfImages = (wallsImgs:getHeight()/mapProp.tileSize)
   
    spriteBatch = love.graphics.newSpriteBatch( wallsImgs, 9000)


    love.graphics.setColorMode("replace")
    love.graphics.setMode(640,480, false, true)
    setQuads(numberOfImages)
    love.mouse.setVisible(false)
    love.mouse.setPosition(screenWidth/2,screenHeight/2)
    love.mouse.setGrab(true)
end
