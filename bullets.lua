BULLETS_TO_DELETE = {}

function manageBullets(dt)                                                         
    deleteUneededBullets() 

    for i,v in ipairs(bullets) do                                                  
        if (v["isVertical"]) then
            v["x"] = v["x"] + (v["dx"] * dt)                                           
            v["y"] = v["y"] + (v["dy"] * dt)                                           
            handleVertical(v,dt,i)
        else
            v["x"] = v["x"] + (v["dx"] * dt)                                           
            v["y"] = v["y"] + (v["dy"] * dt)                                           
        end

        if (v["origin"] > 0) then
            if (enemyBulletHitPlayerCheck(v)) then
                table.remove(bullets,i)
                playerHitDraw()
                player.health = player.health - v["dmg"] 
            end
        end
        if (isBlocking(v, v["x"], v["y"])) then
                table.insert(DECALS, 
                    {
                        x = v["x"] - ((v["dx"]*dt) * 3), 
                        y = v["y"] - ((v["dy"]*dt) * 3), 
                        wallX = v["bulletWallPositionX"],
                        wallY = v["bulletWallPositionY"],
                        verticalPosition = v["verticalPosition"],
                        sprite = 4, 
                        state = v["bulletType"]+1, 
                        visible = false, 
                        decay = 0.1
                    })
                love.audio.stop(soundHit1)
                love.audio.play(soundHit1)
                table.remove(bullets,i)
        end
    end                                                                            
end  

function renderBullets()
    local sqrt = math.sqrt
    local atan2 = math.atan2
    local cos = math.cos
    local tan = math.tan
    local floor = math.floor
    local plyr = player
    local vDist = viewDist
    local scrHeight = screenHeight
    local scrWidth = screenWidth 
    local mTileSize = mapProp.tileSize
    
    for i,v in ipairs(bullets) do
        v["bulletWallPositionX"] = floor(v["x"])
        v["bulletWallPositionY"] = floor(v["y"])

        if (v["visible"] == true) then
            local dx = v["x"] - plyr.x
            local dy = v["y"] - plyr.y

            local dist = sqrt(dx*dx + dy*dy)
            local spriteAngle = atan2(dy, dx) - plyr.rot
            local spriteSize = vDist / (cos(spriteAngle) * dist)

            local spriteX = tan(spriteAngle) * vDist                           
            local top = (scrHeight - spriteSize)/2                                  
            local left = (scrWidth/2 + spriteX - spriteSize/2)                      
            local z = -floor(dist*10000)  
        
            drawCalls[#drawCalls+1] =                                              
            {                                                                      
                z = z,                                                             
                x = left,
                y = top + v["verticalPosition"],                                                           
                dist = dist,                                                       
                sx = spriteSize / mTileSize,                                
                sy = spriteSize / 64,                                              
                quad = SPRITEQUAD[4][v["bulletType"]]                        
            }

            v["visible"] = false
        end
    end
end


function enemyBulletHitPlayerCheck(v)
    local plyr = player
    local dx = v["x"] - plyr.x
    local dy = v["y"] - plyr.y
    local dist = math.sqrt(dx*dx+dy*dy)

    if (dist < 0.4) then
        return true
    end

    return false
end

function createRandomBullet(object, vertical)
    local radiusPoint = math.random(math.pi*2) + math.random()
    local vector = {
        x = math.cos(radiusPoint),
        y = math.sin(radiusPoint)
    }
    local bulletDx = vector.x * object.bulletSpeed
    local bulletDy = vector.y * object.bulletSpeed 
    table.insert(bullets, {
            bulletType = object.bulletImg, 
            x = object.x,
            y = object.y, 
            dx = bulletDx, 
            dy = bulletDy, 
            visible = false, 
            dmg = object.fireDmg,
            objType = "bullet",
            origin = object.id,
            verticalPosition = 0,
            isVertical = vertical,
            peakHit = false
    })
    love.audio.stop(eAttack)
    love.audio.play(eAttack)
end

function createBulletSprite(object)
    local tarX = player.x - object.x
    local tarY = player.y - object.y
    local mag = math.sqrt(tarX*tarX + tarY * tarY)
    local nVectorX = tarX / mag    
    local nVectorY = tarY / mag    
    local bulletDx = nVectorX * object.bulletSpeed
    local bulletDy = nVectorY * object.bulletSpeed 
    table.insert(bullets, {
            bulletType = 1,
            x = object.x, 
            y = object.y, 
            dx = bulletDx, 
            dy = bulletDy, 
            visible = false, 
            dmg = object.fireDmg,
            objType = "bullet",
            origin = object.id,
            verticalPosition = 0
    })
    love.audio.stop(soundShoot)
    love.audio.play(soundShoot)
end

function createBullet(object,tripleShot)
    local startX = object.x                                                                                                                                                  
    local startY = object.y                                                
    local angle = object.rot                                               
    local bulletDx = object.bulletSpeed * math.cos(angle)                   
    local bulletDy = object.bulletSpeed * math.sin(angle)                   
    table.insert(bullets, {
            bulletType = object.bulletImg,
            x = startX, 
            y = startY, 
            dx = bulletDx, 
            dy = bulletDy, 
            visible = false,            
            dmg = object.fireDmg,
            objType = "bullet",
            origin = object.id,
            verticalPosition = 0      
    })
    love.audio.stop(soundShoot)
    love.audio.play(soundShoot)

    if (tripleShot) then
        angle = angle + 0.3
        bulletDx = object.bulletSpeed * math.cos(angle)                   
        bulletDy = object.bulletSpeed * math.sin(angle)                   
        table.insert(bullets, {
                bulletType = object.bulletImg,
                x = startX, 
                y = startY, 
                dx = bulletDx, 
                dy = bulletDy, 
                visible = false,            
                dmg = object.fireDmg,
                objType = "bullet",
                origin = object.id,
                verticalPosition = 0      
        })
        angle = angle - 0.6 
        bulletDx = object.bulletSpeed * math.cos(angle)                   
        bulletDy = object.bulletSpeed * math.sin(angle)                   
        table.insert(bullets, {
                bulletType = object.bulletImg,
                x = startX, 
                y = startY, 
                dx = bulletDx, 
                dy = bulletDy, 
                visible = false,            
                dmg = object.fireDmg,
                objType = "bullet",
                origin = object.id,
                verticalPosition = 0      
        })
    end
end

function handleVertical(object,dt, bulletIndex)
    local peak = -100
    if not (object["peakHit"]) then
        object["verticalPosition"] = object["verticalPosition"] - 300*dt
        if (object["verticalPosition"] < peak) then
            object["peakHit"] = true
        end
    else
        object["verticalPosition"] = object["verticalPosition"] + 200*dt
    end
    if (object["verticalPosition"] > 0) then
        love.audio.stop(soundHit1)
        love.audio.play(soundHit1)
        table.insert(BULLETS_TO_DELETE,bulletIndex)
        object["bulletType"] = 4
    end
end

function deleteUneededBullets() 
    if (#BULLETS_TO_DELETE > 0) then
        for i,v in ipairs(BULLETS_TO_DELETE) do
            table.remove(bullets,BULLETS_TO_DELETE[i])
        end
        BULLETS_TO_DELETE = {}
    end
end

