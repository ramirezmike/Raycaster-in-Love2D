require "raycast"
require "controls"
require "player"
require "util"
require "map"

local spriteBatch
map = {
          5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
          5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
          5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
          5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
          5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,5,
          5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
          5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
          5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
          5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
          5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
  }

QUADS = {}


local selectedWall = 0
--local wallPushDirection = 0
--local miniMapScale = 6
--local numberOfImages = nil
local windowWidth = love.graphics.getWidth() 
local windowHeight = love.graphics.getHeight() 
local screenScale = 0.5
local screenWidth = windowWidth / screenScale
screenHeight = windowHeight / screenScale

local lastGameCycleTime = 0
local gameCycleDelay = 1000 / 60 -- 60 fps for game logic

do
    local fov = 60 * math.pi / 180
    fovHalf = fov/2
end

viewDist = (screenWidth/2) / math.tan(fovHalf)

numRays = math.ceil(screenWidth)  -- THIS SHOULDN"T BE GLOBAL
twoPI = 2 * math.pi

local displayDebug = true
local displayMap = false


local success = love.graphics.setMode( windowWidth, windowHeight)

function move(dt)
    local moveStep = player.speed * player.moveSpeed * dt
    local strafeStep = player.strafeSpeed * math.pi/2

    local mouseLook = 0
    if (love.mouse.isGrabbed()) then
        mouseLook = love.mouse.getX()
        mouseLook = (screenWidth/2) - mouseLook
        mouseLook = mouseLook * player.mouseSpeed * dt
        mouseLook = mouseLook * -1
        love.mouse.setPosition(screenWidth/2,screenHeight/2)
    end

    convertPlayerRotation() -- make sure player is within 360 degrees

    player.rot = player.rot + (player.dir * player.rotSpeed * dt) + mouseLook
    local newX = player.x + math.cos(player.rot ) * moveStep
    local newY = player.y + math.sin(player.rot ) * moveStep
    newX = newX + math.cos(player.rot + math.abs(strafeStep)) * player.strafeSpeed*player.moveSpeed * dt
    newY = newY + math.sin(player.rot + math.abs(strafeStep)) * player.strafeSpeed*player.moveSpeed * dt

    if not (isBlocking(newX,player.y)) then player.x = newX end
    if not (isBlocking(player.x,newY)) then player.y = newY end
end

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

    if (displayMap) then
        drawMiniMap()
    end

    if (displayDebug) then
        love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
        love.graphics.print("player.X   : "..tostring(player.x), 10, 25)
        love.graphics.print("player.Y   : "..tostring(player.y), 10, 40)
        love.graphics.print("player.R   : "..tostring(player.rot), 10, 55)
        love.graphics.print("selWallX   : "..tostring(positionXFromArrayIndex(selectedWall)), 10, 70)
        love.graphics.print("selWallY   : "..tostring(math.floor(positionYFromArrayIndex(selectedWall) + 0.5)), 10, 85)
    end
end

function love.update(dt)
    move(dt)
end

function setQuads(numberOfImages)
    for i=0,numberOfImages-1 do
        QUADS[i]= {}
        for s=0, mapProp.tileSize-1 do
            QUADS[i][s] = love.graphics.newQuad(s,0 + ((i)*mapProp.tileSize),1,mapProp.tileSize,mapProp.tileSize,mapProp.tileSize*numberOfImages)
        end
    end
    floorQuad = love.graphics.newQuad(1,1,1,1,mapProp.tileSize,mapProp.tileSize*numberOfImages)
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
