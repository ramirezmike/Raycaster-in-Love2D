roomSize = 0

function createRoom(roomIndex)
    local level = LEVELS[player.level]
    local room = createEmptyRoom(level.roomSize)
    --printGeneratedRoom(room)


    loadMapFromRoom(room) 
    addObstacles(room)

    clearPathsToDoors(room)
    loadMapFromRoom(room) 
    
    addDoorTop(room,doesRoomHaveTop(roomIndex),roomIndex)
    addDoorBottom(room,doesRoomHaveBottom(roomIndex),roomIndex)
    addDoorLeft(room,doesRoomHaveLeft(roomIndex),roomIndex)
    addDoorRight(room,doesRoomHaveRight(roomIndex),roomIndex)
    loadMapFromRoom(room) 

    addEnemies(room)
--    printGeneratedRoom(room)

    loadMapFromRoom(room) 
    return room
end

function createBossRoom(roomIndex)
    local level = LEVELS[player.level]
    local room = createEmptyRoom(level.bossRoomSize)

    addDoorTop(room,doesRoomHaveTop(roomIndex),roomIndex)
    addDoorBottom(room,doesRoomHaveBottom(roomIndex),roomIndex)
    addDoorLeft(room,doesRoomHaveLeft(roomIndex),roomIndex)
    addDoorRight(room,doesRoomHaveRight(roomIndex),roomIndex)

    if (player.level == 2) then
        addObstacles(room,true)
    end

    return room
end


function createSpawnRoom(roomIndex)
    local size = 10
    local room = createEmptyRoom(size)
    --printGeneratedRoom(room)

    addDoorTop(room,doesRoomHaveTop(roomIndex),roomIndex)
    addDoorBottom(room,doesRoomHaveBottom(roomIndex),roomIndex)
    addDoorLeft(room,doesRoomHaveLeft(roomIndex),roomIndex)
    addDoorRight(room,doesRoomHaveRight(roomIndex),roomIndex)

--    printGeneratedRoom(room)
    loadMapFromRoom(room) 
    return room
end

function printGeneratedRoom(room)
    local roomSize = #room 
    local size = math.sqrt(#room) 

    local mapstring = ""
    for i=0,size-1 do
        mapstring = ""
        for j=0,size-1 do
            local index = roomGenIndexFromCoordinates(room,j,i)
            mapstring = mapstring .. tostring(room[index])
        end 
        print (mapstring)
    end 
end

function roomGenIndexFromCoordinates(room,x,y)                                                                                                                               
    index = 1 + (math.floor(y)*(math.sqrt(#room))) + (math.floor(x))
    return index
end

function createEmptyRoom(size)
    local level = LEVELS[player.level]
    local room = {}
    local roomSizeRoot = size    
    size = size*size

    for i=0,size do
        room[i] = 0
    end

    -- North
    for i=1,roomSizeRoot do
        room[i] = level.door
    end 

    -- Sides
    for i=1,roomSizeRoot-1 do 
        i = i * roomSizeRoot+1
        room[i] = level.door
        for j = 2,roomSizeRoot-1 do
            i = i + 1 
            room[i] = 0 
        end 
        i = i + 1 
        room[i] = level.door
    end 


    -- Bottom
    for i=(size+1)-roomSizeRoot,(size) do
        room[i] = level.door
    end 
    
    return room
end

function clearPathsToDoors(room)
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    for i=2*roomSizeRoot+3,roomSizeRoot*3-2 do
        room[i] = 0
    end
    for i=3+size-(roomSizeRoot*3),size-roomSizeRoot*2-2 do
        room[i] = 0
    end
    for i=roomSizeRoot*3-2,size-roomSizeRoot*2,roomSizeRoot do
        room[i] = 0
    end
    for i=2*roomSizeRoot+3,size-roomSizeRoot*2,roomSizeRoot do
        room[i] = 0
    end
end

function unlockAllDoors()
    local level = LEVELS[player.level]
    local index = getCurrentRoomIndex()
    if (MAPGEN_ROOMS[index].unlockedDoors) then
        return
    end
    for i = 0, #mapProp.map do
        if mapProp.map[i] == level.door then
            mapProp.map[i] = level.uDoor 
        end
    end
    love.audio.stop(doorOpen)
    love.audio.play(doorOpen)
    MAPGEN_ROOMS[index].unlockedDoors = true
end

function addDoorTop(room,roomExists,index)
    local level = LEVELS[player.level]
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=roomSizeRoot+1,roomSizeRoot*2 do
        room[i] = level.wall1 
    end

    if (roomExists) then
        local x = mapGenPositionXFromArrayIndex(index)
        local y = mapGenPositionYFromArrayIndex(index) 
        local indexTop = mapGenIndexFromCoordinates(x,y - 1)

        if (isBossRoom(indexTop)) then
            room[middle] = level.boss 
        end 

        local opening = roomSizeRoot + middle
        room[opening] = 0
    end
end

function addDoorBottom(room,roomExists,index)
    local level = LEVELS[player.level]
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=1+size-(roomSizeRoot*2),size-roomSizeRoot do
        room[i] = level.wall1 
    end

    if (roomExists) then
        local x = mapGenPositionXFromArrayIndex(index)
        local y = mapGenPositionYFromArrayIndex(index) 
        local indexBottom = mapGenIndexFromCoordinates(x,y + 1)

        if (isBossRoom(indexBottom)) then
            room[size-middle+1] = level.boss 
        end 

        local opening = size - roomSizeRoot - middle + 1
        room[opening] = 0
    end
end


function addDoorRight(room,roomExists,index)
    local level = LEVELS[player.level]
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=roomSizeRoot*2-1,size-roomSizeRoot,roomSizeRoot do
        room[i] = level.wall2 
    end

    if (roomExists) then
        local x = mapGenPositionXFromArrayIndex(index)
        local y = mapGenPositionYFromArrayIndex(index) 
        local indexRight = mapGenIndexFromCoordinates(x+1,y)

        if (isBossRoom(indexRight)) then
            room[size - (roomSizeRoot*(middle-1))] = level.boss 
        end 

        local opening = size - (roomSizeRoot*(middle-1)) - 1
        room[opening] = 0
    end
end

function addDoorLeft(room,roomExists,index)
    local level = LEVELS[player.level]
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=roomSizeRoot+2,size-roomSizeRoot,roomSizeRoot do
        room[i] = level.wall2 
    end

    if (roomExists) then
        local x = mapGenPositionXFromArrayIndex(index)
        local y = mapGenPositionYFromArrayIndex(index) 
        local indexLeft = mapGenIndexFromCoordinates(x-1,y)

        if (isBossRoom(indexLeft)) then
            room[size - (roomSizeRoot*(middle-1)) - roomSizeRoot + 1] = level.boss 
        end 

        local opening = size - (roomSizeRoot*(middle-1)) - roomSizeRoot + 2 
        room[opening] = 0
    end
end

function getDoorIndexes(room)
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    
    local left = size - (roomSizeRoot*(middle-1)) - roomSizeRoot + 2 
    local right = size - (roomSizeRoot*(middle-1)) - 1
    local down = size - roomSizeRoot - middle + 1
    local up = roomSizeRoot + middle

    doors = {
        l = left, 
        r = right,
        d = down,
        u = up
    }

    return doors
end

function addObstacles(room,jack)
    local level = LEVELS[player.level]
    if (jack) then
        room[211] = level.obstacle
        return
    end
    local rand = math.random(0,4)

    for i=0,rand do
        local index = getEmptySpot(room,false)
        if (index) then
            room[index] = level.obstacle 
        end
    end
end

function addEnemies(room)
    local level = LEVELS[player.level]
    local rand = math.random(level.minEnemyNumber,level.maxEnemyNumber)

--    rand = 0
    for i=0,rand do
        local index = getEmptySpot(room,false)
        if (index) then
            addSpriteToMap(index,false)
        end
    end
end

function addBoss(room,boss)
    local index = getEmptySpot(room,false)
    addBossToMap(index,boss)
end

function clearTwoSpots(index)
    local x = positionXFromArrayIndex(index) 
    local y = positionXFromArrayIndex(index) 
    local map = mapProp.map
    local size = math.sqrt(#map)


    if (x-2 > 0 and x+2 < size and y+2 < size and y-2 > 0) then
        local newIndex = indexFromCoordinates(x-2,y+2)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x-1,y+2)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+1,y+2)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+2,y+2)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x-2,y+1)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x-1,y+1)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+1,y+1)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+2,y+1)
        if (map[newIndex] > 0) then
            return false
        end

        local newIndex = indexFromCoordinates(x-2,y)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x-1,y)
        if (map[newIndex] > 0) then
            return false 
        end

        newIndex = indexFromCoordinates(x+1,y)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+2,y)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x-2,y-1)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x-1,y-1)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+1,y-1)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+2,y-1)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x-2,y-2)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x-1,y-2)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+1,y-2)
        if (map[newIndex] > 0) then
            return false
        end

        newIndex = indexFromCoordinates(x+2,y-2)
        if (map[newIndex] > 0) then
            return false
        end
        return true
    end
    return false
end


function getEmptySpot(room,clearing)
    local size = #room 
    local roomSizeRoot = math.sqrt(size) 
    local tries = 30 

    while (tries > 0) do
        local rand = math.random(roomSizeRoot*2,size-(roomSizeRoot*2)) 
        if (rand % roomSizeRoot > 2 and rand / roomSizeRoot < roomSizeRoot-2) then
            if (room[rand] == 0) then 
                if (clearing) then
                    if (clearTwoSpots(rand)) then
                        return rand
                    end
                else
                    return rand
                end
            end
        end
        tries = tries - 1
    end
    return 0
end

