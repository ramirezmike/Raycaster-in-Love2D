function dropItem(object)
    local rand = math.random(5)
    if (rand == 1) then
        rand = math.random(5)
        if (rand == 1) then
            createItem(object,itemDoubleHeart())    
        else
            createItem(object,itemHeart())    
        end
    end
end

function testItemDrop(object)
    createItem(object,itemBoxOfDecorations())
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
                quad = SPRITEQUAD[v["itemType"]][v["itemNumber"]]                            
            }   

            v["visible"] = false
        end 
    end                                                                                                                                                                              
end

function saveItemsInCurrentRoom()
    local current = getCurrentRoomIndex()
    MAPGEN_ROOMS[current].items = ITEMS
    ITEMS = {}
end

function loadItemsInRoom(index)
    ITEMS = MAPGEN_ROOMS[index].items
end

function createItem(object,item)
    table.insert(ITEMS, {
            itemType = item.iType, 
            itemNumber = item.iNum,
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
        iType = 2,
        iNum = 0,
        func = function (x) return heartPickup() end
    }
    return item
end

function heartPickup()
    if (player.health < 8) then
        player.health = player.health + 1
        if (player.health > 8) then
            player.health = 8        
        end
        return true
    else
        return false
    end
end

function itemDoubleHeart()
    print ("Double!")
    local item = {
        iType = 2,
        iNum = 1,
        func = function (x) return doubleHeartPickup() end
    }
    return item
end

function doubleHeartPickup()
    if (player.health < 8) then
        player.health = player.health + 2
        if (player.health > 8) then
            player.health = 8        
        end
        return true
    else
        return false
    end
end

function itemBoxOfDecorations()
    print ("Decorations!")
    local item = {
        iType = 2,
        iNum = 2,
        func = function (x) return boxOfDecorations() end
    }
    return item
end

function boxOfDecorations()
    player.fireDmg = player.fireDmg + 1
    player.bulletImg = 5
    player.primary = 5
    print ("DMG: " .. player.fireDmg)
    return true 
end


function deleteUsedItems()
    if (#ITEMS_TO_DELETE > 0) then
        for i,v in ipairs(ITEMS_TO_DELETE) do
            table.remove(ITEMS,ITEMS_TO_DELETE[i])
        end 
        ITEMS_TO_DELETE = {}
    end 
end

