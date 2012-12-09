MAPGEN_MAP = {}
MAPGEN_MAPSIZE = 0 

function createEmptyMapWithSize(size)
    size = size * size
    MAPGEN_MAPSIZE = size
    for i=0,size do
        MAPGEN_MAP[i] = 0
    end
end 

function setSpawnRoom()
    mapSize = #MAPGEN_MAP-1
    sRoom = mapSize / 2
    print (sRoom)
    MAPGEN_MAP[sRoom] = 1
end

function printGeneratedMap()
    local mapstring = ""
    for i=0,math.sqrt(MAPGEN_MAPSIZE)-1 do
        mapstring = ""
        for j=0,math.sqrt(MAPGEN_MAPSIZE)-1 do
            local index = mapGenIndexFromCoordinates(j,i)
            mapstring = mapstring .. tostring(MAPGEN_MAP[index])
        end
        print (mapstring)
    end
end


function generateMap()
    createEmptyMapWithSize(25)
    setSpawnRoom()
    printGeneratedMap()
    print (selectRandomRoom())
    print (numberOfRooms())

    local index = mapGenIndexFromCoordinates(5,5)
    local x = mapGenPositionXFromArrayIndex(index)
    local y = mapGenPositionYFromArrayIndex(index)

    print (index .. "  " .. x .. "  " .. y)

end

function selectRandomRoom()
    local index = math.random(0, MAPGEN_MAPSIZE)
    return index 
end

function numberOfRooms()
    local num = 0
    for i,v in ipairs(MAPGEN_MAP) do
        if (MAPGEN_MAP[i] > 0) then
            num = num + 1
        end
    end
    return num
end

function isNextToARoom(index)
    local roomX = mapGenPositionXFromArrayIndex(index)
    local roomY = mapGenPositionYFromArrayIndex(index)
    
    local potentialRoomX = roomX
    local potentialRoomY = roomY - 1

    if (potentialRoomY > 0) then
        if (MAPGEN_MAP[mapGenIndexFromCoordinates(potentialRoomX,potentialRoomY)] > 0) then
            return true
        end
    end

    potentialRoomY = roomY + 1
    
    if (potentialRoomY < MAPGEN_MAPSIZE - (math.sqrt(MAPGEN_MAPSIZE))) then
        if (MAPGEN_MAP[mapGenIndexFromCoordinates(potentialRoomX,potentialRoomY)] > 0) then
            return true
        end
    end
    
    potentialRoomX = roomX+1
    potentialRoomY = roomY

    if (potentialRoomX < math.sqrt(MAPGEN_MAPSIZE)) then
        if (MAPGEN_MAP[mapGenIndexFromCoordinates(potentialRoomX,potentialRoomY)] > 0) then
            return true
        end
    end
    
    potentialRoomX = roomX-1
    if (potentialRoomX > 0) then
        if (MAPGEN_MAP[mapGenIndexFromCoordinates(potentialRoomX,potentialRoomY)] > 0) then
            return true
        end
    end

    return false
end

function createRooms()
    while (numberOfRooms < maxRooms) do
    end
end

function mapGenIndexFromCoordinates(x,y) 
    index = 1 + (math.floor(y)*(math.sqrt(MAPGEN_MAPSIZE))) + (math.floor(x))
    return index
end

function mapGenPositionXFromArrayIndex(index)
    local x = (index % math.sqrt(MAPGEN_MAPSIZE))-1
    if (x==-1) then x = math.sqrt(MAPGEN_MAPSIZE)-1 end
    return x
end

function mapGenPositionYFromArrayIndex(index)
    local y = ((index-1) / math.sqrt(MAPGEN_MAPSIZE))
    y = math.floor(y)
    return y
end
