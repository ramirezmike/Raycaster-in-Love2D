function ai(dt) 
        for i = 1, #SPRITES do     
            local sprite = SPRITES[i]
            if (sprite.health <= 0) then
                sprite.state = -1
            else
                sprite.frameTimer = sprite.frameTimer + dt*sprite.walkAnimationSpeed
                sprite.strafeSpeed = 0
        
                if (sprite.roasted) then
                    if (sprite.numberOfRoasts == 0) then
                        sprite.roasted = false
                        return
                    end

                    if (sprite.roastedCount < 0) then
                        sprite.numberOfRoasts = sprite.numberOfRoasts - 1
                        sprite.roastedCount = player.roastMax
                        handleSpriteHit(sprite,0.5)
                    end
                    sprite.roastedCount = sprite.roastedCount - dt 
                end
                
                local action = {
                    [5] = function (x) snowmanAI(sprite,dt) end,
                    [0] = function (x) elfAI(sprite,dt) end,
                    [1] = function (x) nutCrackerAI(sprite,dt) end,
                    [3] = function (x) frostyAI(sprite,dt) end,
                    [9] = function (x) frostManAI(sprite,dt) end,
                    [6] = function (x) jackAI(sprite,dt) end,
                    [7] = function (x) nutTeleporterAI(sprite,dt) end,
                    [8] = function (x) santaAI(sprite,dt) end
                }

                action[sprite.img]()
        end
    end

end

function frostyAI(sprite, dt)
            vector = {
                x = 0,
                y = 0 
            }
             
            fireRandomDirection(sprite,dt,false)
            local vectorC = steerAwayFromWalls(sprite)
            local vectorE = steerAwayFromSprites(sprite)
            local vectorF = randomMovement(sprite,dt)

            vector.x = vectorC.x + vectorE.x + vectorF.x
            vector.y = vectorC.y + vectorE.y + vectorF.y

            limitVelocity(sprite,vector)

            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)

            sprite.x = sprite.x + (vector.x  * dt )
            sprite.y = sprite.y + (vector.y  * dt )

            if (dist > 0) then
                sprite.speed = 40
                local numWalkSprites = 4
                if math.floor(sprite.frameTimer) > numWalkSprites then
                    sprite.frameTimer = 1 
                end
                sprite.state = math.floor(sprite.frameTimer) 
            else
                sprite.state = 0
                sprite.speed = 0
            end
            if (sprite.hit) then
                aiHandleHit(sprite, dt)
            end
end


function frostManAI(sprite, dt)
            vector = {
                x = 0,
                y = 0 
            }
             
            fireRandomDirection(sprite,dt,false)
            local vectorC = steerAwayFromWalls(sprite)
            local vectorE = steerAwayFromSprites(sprite)
            local vectorF = randomMovement(sprite,dt)

            vector.x = vectorC.x + vectorE.x + vectorF.x
            vector.y = vectorC.y + vectorE.y + vectorF.y

            limitVelocity(sprite,vector)

            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)

            sprite.x = sprite.x + (vector.x  * dt )
            sprite.y = sprite.y + (vector.y  * dt )

            if (dist > 0) then
                sprite.speed = 40
                local numWalkSprites = 4
                if math.floor(sprite.frameTimer) > numWalkSprites then
                    sprite.frameTimer = 1 
                end
                sprite.state = math.floor(sprite.frameTimer) 
            else
                sprite.state = 0
                sprite.speed = 0
            end
            if (sprite.hit) then
                aiHandleHit(sprite, dt)
            end
end


function santaAI(sprite, dt)
            vector = {
                x = 0,
                y = 0 
            }
             
--            fireRandomDirection(sprite,dt,false)
            local vectorC = steerAwayFromWalls(sprite)
            local vectorE = steerAwayFromSprites(sprite)
            local vectorF = randomMovement(sprite,dt)

            vector.x = vectorC.x + vectorE.x + vectorF.x
            vector.y = vectorC.y + vectorE.y + vectorF.y

            limitVelocity(sprite,vector)

            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)

            sprite.x = sprite.x + (vector.x  * dt )
            sprite.y = sprite.y + (vector.y  * dt )

            if (dist > 0) then
                sprite.speed = 40
                local numWalkSprites = 4
                if math.floor(sprite.frameTimer) > numWalkSprites then
                    sprite.frameTimer = 1 
                end
                sprite.state = math.floor(sprite.frameTimer) 
            else
                sprite.state = 0
                sprite.speed = 0
            end
            if (sprite.hit) then
                aiHandleHit(sprite, dt)
            end
end

function jackAI(sprite, dt)
            if not (jackIntro:isStopped()) then
                return
            end
            vector = {
                x = 0,
                y = 0 
            }
             
            pointV = {
                x = 10.5,
                y = 10.5 
            }

            fireRandomJack(sprite,dt,false)
            spawnEnemies(sprite,dt,5)

            vectorA = steerTowardPoint(sprite,pointV)
    
            vector.x = vectorA.x
            vector.y = vectorA.y

            --limitVelocity(sprite,vector)

            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)

            sprite.x = sprite.x + (vector.x  * dt )
            sprite.y = sprite.y + (vector.y  * dt )

            if (dist > 0) then
                sprite.speed = 40
                local numWalkSprites = 4
                if math.floor(sprite.frameTimer) > numWalkSprites then
                    sprite.frameTimer = 1 
                end
                sprite.state = math.floor(sprite.frameTimer) 
            else
                sprite.state = 0
                sprite.speed = 0
            end
            if (sprite.state == 4) then
                love.audio.stop(jackLand)
                love.audio.play(jackLand)
            end
            if (sprite.hit) then
                aiHandleHit(sprite, dt)
            end
end


function elfAI(sprite, dt)
            vector = {
                x = 0,
                y = 0 
            }
             
            fireRandomDirection(sprite,dt,true)
            local vectorC = steerAwayFromWalls(sprite)
            local vectorE = steerAwayFromSprites(sprite)
--            local vectorF = wander(sprite, vectorC)

            local vectorF = randomMovement(sprite,dt)

            vector.x = vectorC.x + vectorE.x + vectorF.x
            vector.y = vectorC.y + vectorE.y + vectorF.y
            limitVelocity(sprite,vector)


            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)
            

            sprite.x = sprite.x + (vector.x  * dt )
            sprite.y = sprite.y + (vector.y  * dt )


            if (dist > 0) then
                sprite.speed = 40
                local numWalkSprites = 4
                if math.floor(sprite.frameTimer) > numWalkSprites then
                    sprite.frameTimer = 1 
                end
                sprite.state = math.floor(sprite.frameTimer) 
            else
                sprite.state = 0
                sprite.speed = 0
            end
            if (sprite.hit) then
                aiHandleHit(sprite, dt)
            end
end

function nutTeleporterAI(sprite, dt)
            vector = {
                x = 0,
                y = 0 
            }
             
            local vectorC = steerAwayFromWalls(sprite)
            local vectorE = steerAwayFromSprites(sprite)

            local vectorF = randomMovement(sprite,dt)

            vector.x = vectorC.x + vectorE.x + vectorF.x
            vector.y = vectorC.y + vectorE.y + vectorF.y
            --limitVelocity(sprite,vector)


            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)
            



            if (dist > 0.5) then
                sprite.state = 1 
                sprite.x = sprite.x + (vector.x  * dt)
                sprite.y = sprite.y + (vector.y  * dt)
            else
                sprite.state = 0
                handleFire(sprite,dt)
            end
            if (sprite.hit) then
                aiHandleHit(sprite, dt)
            end
end

function nutCrackerAI(sprite, dt)
            if (sprite.detected) then
                sprite.detected = false
                if (sprite.hit) then
                    aiHandleHit(sprite, dt)
                    sprite.state = 0
                end
                return 
            end

            vector = {
                x = 0,
                y = 0 
            }
             

            local vectorA = steerTowardPlayer(sprite)
            local vectorC = steerAwayFromWalls(sprite)
            local vectorD = {x = 0, y = 0}
            local vectorE = steerAwayFromSprites(sprite)

            if (sprite.rotate and vectorC.x == 0 and vectorC.y == 0) then
                sprite.rotateDelay = sprite.rotateDelay - dt
                if (sprite.rotateDelay < 0) then
                    sprite.rotationDirection = math.random(-1,1)
                    sprite.rotateDelay = sprite.rotateDelayMax
                end
                vectorD = rotateAroundPlayer(sprite)
            else
                sprite.rotateDelay = sprite.rotateDelayMax
                sprite.rotationDirection = 0
            end


            vector.x = vectorA.x + vectorC.x + vectorD.x + vectorE.x
            vector.y = vectorA.y + vectorC.y + vectorD.y + vectorE.y
            limitVelocity(sprite,vector)

            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)
            
            sprite.x = sprite.x + (vector.x  * dt )
            sprite.y = sprite.y + (vector.y  * dt )

            if (dist > 0) then
                if (sprite.state == 0) then 
                    sprite.state = 1 
                else
                    sprite.state = 0
                end
                love.audio.stop(ncWalk)
                love.audio.play(ncWalk)
            end

            local distXFromPlayer = player.x - sprite.x
            local distYFromPlayer = player.y - sprite.y
            local distFromPlayer = math.sqrt(distXFromPlayer*distXFromPlayer + distYFromPlayer*distYFromPlayer)
            if (distFromPlayer < 1.4) then
                handleBiteAttack(sprite,dt)
            end
end

function snowmanAI(sprite, dt)
            vector = {
                x = 0,
                y = 0 
            }
             
            handleFire(sprite,dt)
            local vectorA = steerTowardPlayer(sprite)
            local vectorB = backAwayFromPlayer(sprite)
            local vectorC = steerAwayFromWalls(sprite)
            local vectorD = {x = 0, y = 0}
            local vectorE = steerAwayFromSprites(sprite)

            if (sprite.rotate and vectorC.x == 0 and vectorC.y == 0) then
                sprite.rotateDelay = sprite.rotateDelay - dt
                if (sprite.rotateDelay < 0) then
                    sprite.rotationDirection = math.random(-1,1)
                    sprite.rotateDelay = sprite.rotateDelayMax
                end
                vectorD = rotateAroundPlayer(sprite)
            else
                sprite.rotateDelay = sprite.rotateDelayMax
                sprite.rotationDirection = 0
            end


            vector.x = vectorA.x + vectorB.x + vectorC.x + vectorD.x + vectorE.x
            vector.y = vectorA.y + vectorB.y + vectorC.y + vectorD.y + vectorE.y
            limitVelocity(sprite,vector)

            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)
            
            sprite.x = sprite.x + (vector.x  * dt )
            sprite.y = sprite.y + (vector.y  * dt )

            if (dist > 0) then
                sprite.speed = 40
                local numWalkSprites = 4
                if math.floor(sprite.frameTimer) > numWalkSprites then
                    sprite.frameTimer = 1 
                end
                sprite.state = math.floor(sprite.frameTimer) 
            else
                sprite.state = 0
                sprite.speed = 0
            end
            if (sprite.hit) then
                aiHandleHit(sprite, dt)
            end
end

function aiHandleHit(sprite, dt)
    sprite.hitPause = sprite.hitPause - dt
    if (sprite.hitPause <= 0) then
        sprite.hit = false
        sprite.hitPause = 0.2
    end
end

function limitVelocity(sprite, vector)
    local limit = 1.5
    local mag = math.sqrt(vector.x*vector.x + vector.y*vector.y)

    if (mag > limit) then
        vector.x = (vector.x / mag) * limit
        vector.y = (vector.y / mag) * limit
    end
end

function backAwayFromPlayer(sprite)
    local newVectorX = (player.x - sprite.x)
    local newVectorY = (player.y - sprite.y)
    local vectorB = { x = 0, y = 0}

    local mag = math.sqrt(newVectorX*newVectorX + newVectorY*newVectorY)

    if (mag < 2) then
        local pushVectorX = 0
        local pushVectorY = 0
        pushVectorX = pushVectorX - (newVectorX)
        pushVectorY = pushVectorY - (newVectorY)

        vectorB.x = pushVectorX*2
        vectorB.y = pushVectorY*2
    end
    return vectorB
end

function steerTowardPlayer(sprite)
    local newVectorX = (player.x - sprite.x)
    local newVectorY = (player.y - sprite.y)
    local vectorA = { x = 0, y = 0}

    local mag = math.sqrt(newVectorX*newVectorX + newVectorY*newVectorY)
    if (mag < sprite.visiblityRange) then  -- this will be based on sprite's acceptable distance from player and if "chase" is true
        sprite.playerVisible = true
        vectorA.x = newVectorX 
        vectorA.y = newVectorY 
    end
    return vectorA
end

function rotateAroundPlayer(sprite)
    local newVectorX = (player.x - sprite.x)
    local newVectorY = (player.y - sprite.y)
    local vectorD = {x = 0, y = 0}

    local cos = math.cos
    local sin = math.sin
    local angle = sprite.rotationAngle * sprite.rotationDirection

    local mag = math.sqrt(newVectorX*newVectorX + newVectorY*newVectorY)
    
    if (mag < 4) then
        local x = ((sprite.x - player.x) * cos(angle)) - ((player.y - sprite.y) * sin(angle))
        local y = ((player.y - sprite.y) * cos(angle)) - ((sprite.x - player.x) * sin(angle))

        vectorD.x = x
        vectorD.y = y
    end
    return vectorD
end

function handleFire(sprite,dt)
    if (sprite.playerVisible) then
        if (sprite.fireRate < 0) then 
            sprite.fireRate = sprite.maxFireRate
        elseif (sprite.fireRate == sprite.maxFireRate) then
            createBulletSprite(sprite)
            sprite.fireRate = sprite.fireRate - dt
        else
            sprite.fireRate = sprite.fireRate - dt
        end
    end
end

function spawnEnemies(sprite,dt,numberOfEnemies)
    if (#SPRITES > 5) then
        return
    end

    if (sprite.spawnRate < 0) then
        sprite.spawnRate = sprite.maxSpawnRate
    elseif (sprite.spawnRate == sprite.maxSpawnRate) then
        sprite.spawnRate = sprite.spawnRate - dt
        local currentRoomIndex = getCurrentRoomIndex()
        local room = MAPGEN_ROOMS[currentRoomIndex].room
        for i=1,numberOfEnemies do
            local index = getEmptySpot(room,false)
            addSpriteToMap(index,true,1,2)
        end
        -- add sound
    else
        sprite.spawnRate = sprite.spawnRate - dt
    end
end

function fireRandomDirection(sprite,dt,vertical)
    if (sprite.fireRate < 0) then 
        sprite.fireRate = sprite.maxFireRate
    elseif (sprite.fireRate == sprite.maxFireRate) then
        sprite.fireRate = sprite.fireRate - dt
        for i = 1, sprite.maxBullets do
            createRandomBullet(sprite,vertical)
        end
    else
        sprite.fireRate = sprite.fireRate - dt
    end
end


function fireRandomJack(sprite,dt)
    if (sprite.fireRate < 0) then 
        sprite.fireRate = sprite.maxFireRate
    elseif (sprite.fireRate == sprite.maxFireRate) then
        sprite.fireRate = sprite.fireRate - dt
        for i = 1, sprite.maxBullets do
            createJackBullet(sprite)
        end
    else
        sprite.fireRate = sprite.fireRate - dt
    end
end

function handleBiteAttack(sprite,dt)
    if (sprite.fireRate < 0) then 
        sprite.fireRate = sprite.maxFireRate
    elseif (sprite.fireRate == sprite.maxFireRate) then
        sprite.fireRate = sprite.fireRate - dt
        if (sprite.state == 1) then
            player.health = player.health - sprite.fireDmg 
            love.audio.stop(ncAttack)
            love.audio.play(ncAttack)
        end
    else
        sprite.fireRate = sprite.fireRate - dt
    end
end

function steerAwayFromSprites(sprite)
    local newVectorX = 0
    local newVectorY = 0
    local vectorE = {x = 0, y = 0}

    for i,v in ipairs(SPRITES) do
        if (v ~= sprite) then
            dx = v["x"] - sprite.x
            dy = v["y"] - sprite.y
            if (math.sqrt(dx*dx + dy*dy) < 1.0) then
                newVectorX = (newVectorX - dx)*2
                newVectorY = (newVectorY - dy)*2
            end
        end
    end
    
    vectorE.x = newVectorX
    vectorE.y = newVectorY

    return vectorE
end

function steerAwayFromWalls(sprite)
    local newVectorX = 0
    local newVectorY = 0
    local vectorC = {x = 0, y = 0}
    local mag = 4

    for i,v in ipairs(wallPositions) do
        dx = v["x"] - sprite.x
        dy = v["y"] - sprite.y
        local wall = math.sqrt(dx*dx + dy*dy)
        if (wall  < 1.4) then
            newVectorX = (newVectorX - dx) * (mag/wall)
            newVectorY = (newVectorY - dy) * (mag/wall) 
        end
    end
    
    vectorC.x = newVectorX
    vectorC.y = newVectorY
    return vectorC
end

function setupRandomMovement(sprite)
    sprite.randSetup = true
    sprite.randomMovementIndex = 0
    sprite.randomMovementTime = 0
    sprite.randomMovementMaxTime = 5
end

function steerTowardPoint(sprite,point)
    local newVectorX = (point.x - sprite.x)
    local newVectorY = (point.y - sprite.y)
    local vectorA = { x = 0, y = 0}

    local mag = math.sqrt(newVectorX*newVectorX + newVectorY*newVectorY)
    vectorA.x = newVectorX 
    vectorA.y = newVectorY 
    return vectorA
end

function randomMovement(sprite,dt)
    if (sprite.randSetup == nil) then
        setupRandomMovement(sprite)
    end

    sprite.randomMovementTime = sprite.randomMovementTime - dt

    if (sprite.randomMovementIndex == indexFromCoordinates(sprite.x,sprite.y) or
        sprite.randomMovementTime < 0) then
        sprite.randomMovementIndex = getEmptySpot(MAPGEN_ROOMS[getCurrentRoomIndex()].room, false)
        sprite.randomMovementTime = sprite.randomMovementMaxTime
    end

    local newVector = {
        x = positionXFromArrayIndex(sprite.randomMovementIndex) - sprite.x,
        y = positionYFromArrayIndex(sprite.randomMovementIndex) - sprite.y 
    }
    
    return newVector
end

function wander(sprite,wallVector)
    local wRadius = 15
    local wDist = 2
    local change = 0.25 
    sprite.theta = sprite.theta + math.random(-change,change) 

    local circleLoc = {
        x = wallVector.x - sprite.x,        
        y = wallVector.y - sprite.y 
    }

    circleLoc = normalizeVector(circleLoc)
    circleLoc.x = circleLoc.x * wDist
    circleLoc.y = circleLoc.y * wDist
    circleLoc.x = circleLoc.x + sprite.x
    circleLoc.y = circleLoc.y + sprite.y


                  table.insert(DECALS, 
                    {   
                        x = circleLoc.x, 
                        y = circleLoc.y,
                        wallX = math.floor(circleLoc.x),
                        wallY = math.floor(circleLoc.y),
                        sprite = 4,  
                        state = 2,  
                        visible = false, 
                        decay = 0.1 
                    })  
 

    local offSet = {
        x = wRadius * math.cos(sprite.theta),
        y = wRadius * math.sin(sprite.theta)
    }

    local targetVector = {
        x = (circleLoc.x + offSet.x) ,
        y = (circleLoc.y + offSet.y) 
    }

    local desiredLoc = {
        x = targetVector.x - sprite.x,
        y = targetVector.y - sprite.y
    }

    if (inWall(circleLoc)) then
        desiredLoc = rotateAroundOrigin(circleLoc.x,circleLoc.y, sprite.x, sprite.y, 90)
    end
    return desiredLoc 
end

function inWall(vector)
    for i,v in ipairs(wallPositions) do
        local dx = v["x"] - vector.x
        local dy = v["y"] - vector.y
        local wall = math.sqrt(dx*dx + dy*dy)
        if (wall < 1) then
            return true
        end
    end
    return false
end
    
function bossEndLevelCheck(sprite)
    if (sprite.health < 1) then
        fadeToBlackSetup()
    end
end
