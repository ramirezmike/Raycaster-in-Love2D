function dropItem(object)
    if (object.isSpecial) then
        createSpecialItem(object)
        return
    end

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
    createItem(object,itemRudolphNose())
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
    if (MAPGEN_ROOMS[index].items) then
        ITEMS = MAPGEN_ROOMS[index].items
    end
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

function createSpecialItem(object)
    local itemsList = {}
    local rudolph = { func = function (x) return itemRudolphNose() end }
    local box = { func = function (x) return itemBoxOfDecorations() end }
    local candy = { func = function (x) return itemCandyCanes() end }
    local snowMachine= { func = function (x) return itemSnowMachine() end }
    local tripShot = { func = function (x) return itemTripleShot() end }
    local rNuts = { func = function (x) return itemRoastedNuts() end }
    local twelveDays = { func = function (x) return itemTwelveDays() end }

    table.insert(itemsList, rudolph)
    table.insert(itemsList, box)
    table.insert(itemsList, candy)
    table.insert(itemsList, snowMachine)
    table.insert(itemsList, tripShot)
    table.insert(itemsList, rNuts)
    table.insert(itemsList, twelveDays)

    local rand = math.random(#itemsList)
    local itemCreated = itemsList[rand].func()
    createItem(object,itemCreated)
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
    return true 
end


function itemCandyCanes()
    local item = {
        iType = 2,
        iNum = 3,
        func = function (x) return candyCanes() end
    }
    return item
end

function candyCanes()
    player.maxFireRate = player.maxFireRate - 0.1 
    if (player.maxFireRate <= 0) then
        player.maxFireRate = 0.1
    end
    player.bulletSpeed = player.bulletSpeed + 1
    player.bulletImg = 7
    player.primary = 7
    return true 
end


function itemSnowMachine()
    local item = {
        iType = 2,
        iNum = 4,
        func = function (x) return snowMachine() end
    }
    return item
end

function snowMachine()
    player.maxFireRate = player.maxFireRate - 0.2 
    if (player.maxFireRate <= 0) then
        player.maxFireRate = 0.1
    end
    player.bulletImg = 1
    player.primary = 1
    return true 
end


function itemTripleShot()
    local item = {
        iType = 2,
        iNum = 5,
        func = function (x) return tripleShot() end
    }
    return item
end

function tripleShot()
    player.tripleShot= true
    return true 
end

function itemRoastedNuts()
    local item = {
        iType = 2,
        iNum = 6,
        func = function (x) return roastedNuts() end
    }
    return item
end

function roastedNuts()
    player.bulletImg = 9
    player.primary = 9
    player.roasted = true 
    return true 
end

function itemTwelveDays()
    local item = {
        iType = 2,
        iNum = 7,
        func = function (x) return twelveDays() end
    }
    return item
end

function twelveDays()
    player.secondary = 7
    return true 
end

function fireTwelveDays()
    if (twelveDaysRate) then
        if (twelveDaysRate >= 0) then
            createTwelveBullet(player,twelveDaysNumber)
            twelveDaysRate = twelveDaysRate - 1
        else
            twelveDaysRate = nil
            player.secondaryRecharge = false
            player.secondFiring = false
        end
    else
        twelveDaysNumber = math.random(0,11) 
        twelveDaysRate = twelveDaysNumber
    end
end


function itemRudolphNose()
    local item = {
        iType = 2,
        iNum = 8,
        func = function (x) return rudolphNose() end
    }
    return item
end

function rudolphNose()
    player.secondary = 8
    return true 
end

function fireRudolphNose()
    if (rudolphFiring) then
        if (rudolphFiring < 0) then
            player.secondaryRecharge = false
            player.secondFiring = false
        else
            createRudolphBullet(player)
            rudolphFiring = rudolphFiring - 1
        end
    else
        rudolphFiring = 50
    end
end

function deleteUsedItems()
    if (#ITEMS_TO_DELETE > 0) then
        for i,v in ipairs(ITEMS_TO_DELETE) do
            table.remove(ITEMS,ITEMS_TO_DELETE[i])
        end 
        ITEMS_TO_DELETE = {}
    end 
end


SECONDARY = {}
table.insert(SECONDARY,7,function (x) fireTwelveDays() end)
table.insert(SECONDARY,8,function (x) fireRudolphNose() end)
SECONDARY_RATES = {}
table.insert(SECONDARY_RATES,7,3)
table.insert(SECONDARY_RATES,8,17)
