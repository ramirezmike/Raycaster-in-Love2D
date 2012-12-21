function dropItem(object)
    createItem(object,itemHeart())    
end

function renderItems()
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
        
    for i,v in ipairs(ITEMS) do
        v["itemWallPositionX"] = floor(v["x"])
        v["itemWallPositionY"] = floor(v["y"])

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
                quad = SPRITEQUAD[2][0]                            
            }   

            v["visible"] = false
        end 
    end                                                                                                                                                                              
end

function createItem(object,item)
    print (item)
    table.insert(ITEMS, {
            itemType = item.iType, 
            itemNumber = 0,
            x = object.x,
            y = object.y, 
            visible = false, 
            objType = "item",
            verticalPosition = 0,
            isVertical = false,
            peakHit = false,
            pickupFunction = function (x) return item.func() end
    })
end

function itemHeart()
    local item = {
        iType = 0,
        func = function (x) return heartPickup() end
    }
    return item
end

function deleteUsedItems()
    if (#ITEMS_TO_DELETE > 0) then
        for i,v in ipairs(ITEMS_TO_DELETE) do
            table.remove(ITEMS,ITEMS_TO_DELETE[i])
        end 
        ITEMS_TO_DELETE = {}
    end 
end

function heartPickup()
    if (player.health < 8) then
        player.health = player.health + 0.5
        return true
    else
        return false
    end
end
