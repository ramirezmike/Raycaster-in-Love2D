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
             
            steerTowardPlayer(sprite,vector)
            steerAwayFromSprites(sprite,vector)
            steerAwayFromWalls(sprite,vector)

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
            --move(SPRITES[i], dt)
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

function steerTowardPlayer(sprite,vector)
    newVectorX = (player.x - sprite.x)
    newVectorY = (player.y - sprite.y)

    local mag = math.sqrt(newVectorX*newVectorX + newVectorY*newVectorY)
    if (mag < 10) then  -- this will be based on sprite's acceptable distance from player and if "chase" is true
        vector.x = newVectorX 
        vector.y = newVectorY 
    end
    if (mag < 3) then
        local pushVectorX = 0
        local pushVectorY = 0
        pushVectorX = pushVectorX - (vector.x)
        pushVectorY = pushVectorY - (vector.y)

        vector.x = vector.x + pushVectorX
        vector.y = vector.y + pushVectorY
    end
end

function steerWithinBoundry(sprite)
    local xMin = 1
    local yMin = 1
    local xMax = mapProp.mapWidth - 1 
    local yMax = mapProp.mapHeight - 1 

    local vector = 0
    
    if (sprite.x < xMin) then
        
    elseif (sprite.x > xMax) then
    end

end

function steerAwayFromSprites(sprite,vector)
    local newVectorX = 0
    local newVectorY = 0

    for i,v in ipairs(SPRITES) do
        if (v ~= sprite) then
            dx = v["x"] - sprite.x
            dy = v["y"] - sprite.y
            if (math.sqrt(dx*dx + dy*dy) < 1.0) then
                newVectorX = newVectorX - dx
                newVectorY = newVectorY - dy
            end
        end
    end
    
    vector.x = vector.x + newVectorX
    vector.y = vector.y + newVectorY
end

function steerAwayFromWalls(sprite,vector)
    local newVectorX = 0
    local newVectorY = 0
    local mag = 2

    for i,v in ipairs(wallPositions) do
        dx = v["x"] - sprite.x
        dy = v["y"] - sprite.y
        if (math.sqrt(dx*dx + dy*dy) < 1.4) then
            newVectorX = (newVectorX - dx) * 4
            newVectorY = (newVectorY - dy) * 4
        end
    end
    
    vector.x = vector.x + newVectorX
    vector.y = vector.y + newVectorY
end
