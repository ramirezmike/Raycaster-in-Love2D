function sort(T) table.sort(T, function(a, b) return a.z < b.z end ) end

function indexFromCoordinates(x,y)
    local x = math.abs(x)
    local y = math.abs(y)
    index = 1 + (math.floor(y)*mapProp.mapWidth) + (math.floor(x))
    return index
end

function positionXFromArrayIndex(index)
    local x = (index % mapProp.mapWidth)-1
    local y = (index - x)/mapProp.mapWidth
    return x
end

function positionYFromArrayIndex(index)
    local x = (index % mapProp.mapWidth)-1
    local y = (index - x)/mapProp.mapWidth
    return y
end

function normalizeVector(vector)
    local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)
    local v = {
        x = vector.x/dist,
        y = vector.y/dist,
    }
    return v
end

function isBlocking(object, newX, newY)
    if (object.objType == "sprite") then
        return false
    end

    local x = newX
    local y = newY 
    local floor = math.floor
    local sqrt = math.sqrt

    if (y < 0 + distanceFromWalls or y > mapProp.mapHeight - distanceFromWalls or x < 0 + distanceFromWalls or x > mapProp.mapWidth - distanceFromWalls) then
        return true
    end

    if (object.objType == "player") then
        for i=1,#ITEMS do
            local item = ITEMS[i]
                local dx = item.x - x
                local dy = item.y - y
                local dist = sqrt(dx*dx + dy*dy)
    
                if (dist < 0.3) then
                    local success = item.pickupFunction()
                    if (success) then
                        love.audio.stop(pickup)
                        love.audio.play(pickup)
                        table.insert(ITEMS_TO_DELETE, i)
                    end
                end
            
        end
    end
    deleteUsedItems()

    for i=1,#SPRITES do
        local sprite = SPRITES[i]

        if (sprite.block == true) then
            local dx = sprite.x - x
            local dy = sprite.y - y
            local dist = sqrt(dx*dx + dy*dy)
            if (object.objType == "bullet" and object.origin == 0) then
                if (dist < 0.3) then
                    handleSpriteHit(sprite,object.dmg)

                    if (player.roasted) then
                        sprite.roasted = true
                        sprite.roastedCount = player.roastMax
                        sprite.numberOfRoasts = player.roastNumber
                    end

                    return true
                end
            end
        end
    end

    local reg = 1+(floor(y) * mapProp.mapWidth) + floor(x)

    if (mapProp.map[reg] > 0) then
        return true
    end

    return false
end

function changeTexture()
    for i = 0,(mapProp.mapWidth*mapProp.mapHeight) do
        if (mapProp.map[i] == 4) then mapProp.map[i] = 5 end
        if (mapProp.map[i] == 3) then mapProp.map[i] = 4 end
        if (mapProp.map[i] == 2) then mapProp.map[i] = 3 end
        if (mapProp.map[i] == 1) then mapProp.map[i] = 2 end
        if (mapProp.map[i] == 5) then mapProp.map[i] = 1 end
    end 
end

function setQuads(imagesPerHeight,imagesPerWidth, itemsPerHeight, itemsPerWidth)
    for i=0,imagesPerHeight-1 do
        QUADS[i]= {}
        for s=0, mapProp.tileSize-1 do
            QUADS[i][s] = love.graphics.newQuad(s,0 + ((i)*mapProp.tileSize),1,mapProp.tileSize,
                mapProp.tileSize*imagesPerWidth,mapProp.tileSize*imagesPerHeight)
        end 
    end 
    for i=0,imagesPerHeight-1 do
        SPRITEQUAD[i] = {}
        for s=0,imagesPerWidth-1 do
           SPRITEQUAD[i][s] = love.graphics.newQuad(mapProp.tileSize+1+(s*mapProp.tileSize), 0+(i*mapProp.tileSize+1), 
            mapProp.tileSize, mapProp.tileSize,imagesPerWidth*mapProp.tileSize, imagesPerHeight*mapProp.tileSize) 
        end
    end
    BGQUAD[1] = love.graphics.newQuad(0,0,1,480,1,480)
    MINIQUAD[1] = love.graphics.newQuad(0,0,6,6,18,6)
    MINIQUAD[2] = love.graphics.newQuad(6,0,6,6,18,6)
    MINIQUAD[3] = love.graphics.newQuad(12,0,6,6,18,6)
--    floorQuad = love.graphics.newQuad(1,1,1,1,mapProp.tileSize,mapProp.tileSize*numberOfImages)

end 

function drawDebug()
    love.graphics.setColor(0,0,0)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("sprite.X   : "..tostring(player.x), 10, 100)
    love.graphics.print("sprite.Y   : "..tostring(player.y), 10, 115)
    love.graphics.print("player.I   : "..indexFromCoordinates(player.x,player.y), 10, 55)
--    love.graphics.print("selWallX   : "..tostring(positionXFromArrayIndex(selectedWall)), 10, 70)
--    love.graphics.print("selWallY   : "..tostring(math.floor(positionYFromArrayIndex(selectedWall) + 0.5)), 10, 85)
--    love.graphics.print("sprite.X   : "..tostring(SPRITES[1].x), 10, 100)
--    love.graphics.print("sprite.Y   : "..tostring(SPRITES[1].y), 10, 115)
end

function drawMiniMap()
    local mWidth = math.sqrt(#MAPGEN_MAP)
    local currentRoom = getCurrentRoomCoordinates()
    
    miniMapWidth = mWidth * mapProp.miniMapScale
    miniMapHeight = mWidth * mapProp.miniMapScale

    mapOffsetX = 0 --500
    mapOffsetY = 370 --340

    love.graphics.setColor(255,255,255)
    local i=1
    for y=0,mWidth-1 do
        for x=0,mWidth-1 do
            local wall = MAPGEN_MAP[i]
   
            if (wall>0) then
                love.graphics.setColor(0,0,90)
                if (MAPGEN_ROOMS[mapGenIndexFromCoordinates(x,y)] and SPECIAL_ROOMS[mapGenIndexFromCoordinates(x,y)] == nil) then
                    love.graphics.setColor(0,0,200)
                end
                if (x == currentRoom.x and y == currentRoom.y) then
                    love.graphics.setColor(200,200,0)
                end
                love.graphics.rectangle( "fill",
                    x * mapProp.miniMapScale + mapOffsetX,
                    y * mapProp.miniMapScale + mapOffsetY,
                    mapProp.miniMapScale, mapProp.miniMapScale)
            end
            i = i + 1
        end
    end
end

function createMiniMap()
    mapSpriteBatch:clear()
    local mWidth = math.sqrt(#MAPGEN_MAP)
    local currentRoom = getCurrentRoomCoordinates()
    
    miniMapWidth = mWidth * mapProp.miniMapScale
    miniMapHeight = mWidth * mapProp.miniMapScale

    mapOffsetX = 0 --500
    mapOffsetY = 370 --340

    local i=1
    for y=0,mWidth-1 do
        for x=0,mWidth-1 do
            local wall = MAPGEN_MAP[i]
   
            if (wall>0) then
                mapSpriteBatch:addq(MINIQUAD[1],x * mapProp.miniMapScale + mapOffsetX, y * mapProp.miniMapScale + mapOffsetY)

                if (MAPGEN_ROOMS[mapGenIndexFromCoordinates(x,y)] and SPECIAL_ROOMS[mapGenIndexFromCoordinates(x,y)] == nil) then
                    mapSpriteBatch:addq(MINIQUAD[2],x * mapProp.miniMapScale + mapOffsetX, y * mapProp.miniMapScale + mapOffsetY)
                end

                if (x == currentRoom.x and y == currentRoom.y) then
                    mapSpriteBatch:addq(MINIQUAD[3],x * mapProp.miniMapScale + mapOffsetX, y * mapProp.miniMapScale + mapOffsetY)
                end
            end
            i = i + 1
        end
    end
end

function move(object, dt)
    local cos = math.cos
    local sin = math.sin
    local abs = math.abs

    local moveStep = object.speed * object.moveSpeed * dt
    local strafeStep = object.strafeSpeed * math.pi/2

    local mouseLook = 0
    if (love.mouse.isGrabbed()) then
        mouseLook = love.mouse.getX()
        mouseLook = (screenWidth/2) - mouseLook
        mouseLook = mouseLook * player.mouseSpeed * dt
        mouseLook = mouseLook * -1
        love.mouse.setPosition(screenWidth/2,screenHeight/2)
    end

    convertPlayerRotation() -- make sure player is within 360 degrees

    object.rot = object.rot + (object.dir * object.rotSpeed * dt) + mouseLook
    local newX = object.x + cos(object.rot ) * moveStep
    local newY = object.y + sin(object.rot ) * moveStep
    newX = newX + cos(object.rot + abs(strafeStep)) * object.strafeSpeed*object.moveSpeed * dt
    newY = newY + sin(object.rot + abs(strafeStep)) * object.strafeSpeed*object.moveSpeed * dt
    
    if not (isBlocking(object, newX, object.y)) then object.x = newX end
    if not (isBlocking(object, object.x, newY)) then object.y = newY end
end

function polarOffset(x, y, dist, angle)
    point = {}
    point.x = x + dist * math.cos(angle)
    point.y = y + dist * math.sin(angle)
    return point
end

function rotateAroundOrigin(x, y, originX, originY, angle)
    point = {}
    point.x = ((x - originX) * math.cos(angle)) - ((originY - y) * math.sin(angle)) + originX
    point.y = ((y - originY) * math.cos(angle)) - ((originY - y) * math.sin(angle)) + originY
    return point
end

function drawBackground()
    for i = 1, screenWidth do
       love.graphics.drawq(bgImg,BGQUAD[1],i,0,0,1,1)
    end
end


function drawSceneChange()
    local level = LEVELS[player.level]
    local text = level.introText 
    textFont = love.graphics.newFont()
    love.graphics.setColor(255,255,255)
    love.graphics.setFont(textFont)
    if (player.mapGenX == nil) then
        love.graphics.printf("Loading...",0,screenHeight/2,screenWidth,'center') 
    else
        love.graphics.printf("Press any Key",0,screenHeight/2,screenWidth,'center') 
    end
    love.graphics.print(text, 400,415)
end

function deleteAllSprites()
    for i, v in ipairs(SPRITES) do
        table.insert(SPRITES_TO_DELETE,i)
    end
end

function fadeToBlackSetup()
    fadeAmount = 0 
    fadeColor = function (x) love.graphics.setColor(0,0,0,fadeAmount) end 
    fade= function (x) love.graphics.rectangle("fill",0,0,screenWidth,screenHeight) end 
    fading = true
end

function fadeToBlack()
    fadeAmount = fadeAmount + 2
    fadeColor()
    fade()
    
    if fadeAmount > 255 then
        fading = false
        if (player.dead) then
            restartGame()
        else
            changeLevel()
        end
    end
end

function restartGame()
        stopAllMusic()
        loadMainMenu()
        love.mouse.setVisible(true)
        gameRunning = false
        mainMenuDisplaying = true
        love.audio.play(mainMenuMusic)
        mainMenuMusic:setLooping(true)
        player.dead = false
        player.level = 0
        player.health = 8
        player = defaultPlayer
end

function stopAllMusic()
    love.audio.stop(mainMenuMusic)
    love.audio.stop(level1Music)
    love.audio.stop(level2Music)
    love.audio.stop(level3Music)
    love.audio.stop(bossMusic)
end

function playCurrentLevelMusic()
    stopAllMusic()
    local music = {
        [1] = function (x) love.audio.play(level1Music) level1Music:setLooping(true) end,
        [2] = function (x) love.audio.play(level2Music) level2Music:setLooping(true) end,
        [3] = function (x) love.audio.play(level3Music) level3Music:setLooping(true) end
    }
    music[player.level]()
end
