function ai(dt)
    for i = 1, #SPRITES do     
        local sprite = SPRITES[i]
        if (sprite.health <= 0) then
            sprite.state = 10
            sprite.block = false
        else
            sprite.frameTimer = sprite.frameTimer + dt*sprite.walkAnimationSpeed
            sprite.strafeSpeed = 0

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


--            local p1 = polarOffset(sprite.x,sprite.y,0.5,angle+0.7)                  
--            angle = angle + steerAwayFromWalls(p1)
--            local p2 = polarOffset(sprite.x,sprite.y,0.5,angle-0.7)                  
--            angle = angle + steerAwayFromWalls(p2)

            local dist = math.sqrt(vector.x*vector.x + vector.y*vector.y)
            
            local angle = math.atan(vector.y/vector.x)

            sprite.x = sprite.x + (vector.x  * dt )
            sprite.y = sprite.y + (vector.y  * dt )


            --sprite.rot = angle

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
    end

end

function aiHandleHit(sprite, dt)
    sprite.hitPause = sprite.hitPause - dt
    if (sprite.hitPause <= 0) then
        sprite.hit = false
        sprite.hitPause = 0.2
    else
        sprite.state = 5
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
