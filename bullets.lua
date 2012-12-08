function manageBullets(dt)                                                         
    for i,v in ipairs(bullets) do                                                  
        v["x"] = v["x"] + (v["dx"] * dt)                                           
        v["y"] = v["y"] + (v["dy"] * dt)                                           
        if (v["origin"] > 0) then
            if (enemyBulletHitPlayerCheck(v)) then
                table.remove(bullets,i)
            end
        end
        if (isBlocking(v, v["x"], v["y"])) then
                table.insert(DECALS, 
                    {
                        x = v["x"] - ((v["dx"]*dt) * 3), 
                        y = v["y"] - ((v["dy"]*dt) * 3), 
                        wallX = v["bulletWallPositionX"],
                        wallY = v["bulletWallPositionY"],
                        sprite = 4, 
                        state = 2, 
                        visible = false, 
                        decay = 0.1
                    })
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
                y = top,                                                           
                dist = dist,                                                       
                sx = spriteSize / mTileSize,                                
                sy = spriteSize / 64,                                              
                quad = SPRITEQUAD[4][1]                        
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

function createBulletSprite(object)
    local tarX = player.x - object.x
    local tarY = player.y - object.y
    local mag = math.sqrt(tarX*tarX + tarY * tarY)
    local nVectorX = tarX / mag    
    local nVectorY = tarY / mag    
    local bulletDx = nVectorX * object.bulletSpeed
    local bulletDy = nVectorY * object.bulletSpeed 
    table.insert(bullets, {x = object.x, y = object.y, dx = bulletDx, dy = bulletDy, visible = false, objType = "bullet",origin = object.id})
end

function createBullet(object)
    local startX = object.x                                                                                                                                                  
    local startY = object.y                                                
    local angle = object.rot                                               
    local bulletDx = object.bulletSpeed * math.cos(angle)                   
    local bulletDy = object.bulletSpeed * math.sin(angle)                   
    table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy, visible = false, objType = "bullet",origin = object.id})
end
