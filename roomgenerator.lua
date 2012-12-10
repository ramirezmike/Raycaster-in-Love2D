roomSize = 0

function createRoom()
    local size = 10
    local room = createEmptyRoom(size)
    printGeneratedRoom(room)
    print(#room)


    addDoorTop(room,true)
    addDoorBottom(room,true)
    addDoorRight(room,true)
    addDoorLeft(room,true)
    addObstacles(room)
    clearPathsToDoors(room)
    printGeneratedRoom(room)

    loadMapFromRoom(room) 
    local spawn = getEmptySpot(room,false)
    player.x = positionXFromArrayIndex(spawn) 
    player.y = positionYFromArrayIndex(spawn) 
    print ("PLAYER SPAWN INDEX = " .. spawn)
    print ("Map at spawn = " .. tostring(room[spawn]))
    print ("PLAYER SPAWN: " .. player.x .. "  " .. player.y)
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
    local room = {}
    local roomSizeRoot = size    
    size = size*size

    for i=0,size do
        room[i] = 0
    end

    for i=1,roomSizeRoot do
        room[i] = 1 
    end 

    for i=1,roomSizeRoot-1 do 
        i = i * roomSizeRoot+1
        room[i] = 1 
        for j = 2,roomSizeRoot-1 do
            i = i + 1 
            room[i] = 0 
        end 
        i = i + 1 
        room[i] = 1 
    end 


    for i=(size+1)-roomSizeRoot,(size) do
        room[i] = 1 
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

function addDoorTop(room,roomExists)
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=roomSizeRoot+1,roomSizeRoot*2 do
        room[i] = 3
    end

    if (roomExists) then
        local opening = roomSizeRoot + middle
        room[opening] = 0
    end
end

function addDoorBottom(room,roomExists)
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=1+size-(roomSizeRoot*2),size-roomSizeRoot do
        room[i] = 2
    end

    if (roomExists) then
        local opening = size - roomSizeRoot - middle + 1
        room[opening] = 0
    end
end


function addDoorRight(room,roomExists)
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=roomSizeRoot*2-1,size-roomSizeRoot,roomSizeRoot do
        room[i] = 4
    end

    if (roomExists) then
        local opening = size - (roomSizeRoot*(middle-1)) - 1
        room[opening] = 0
    end
end

function addDoorLeft(room,roomExists)
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=roomSizeRoot+2,size-roomSizeRoot,roomSizeRoot do
        room[i] = 5
    end

    if (roomExists) then
        local opening = size - (roomSizeRoot*(middle-1)) - roomSizeRoot + 2 
        room[opening] = 0
    end
end

function addObstacles(room)
    local rand = math.random(0,5)
    print ("THIS IS RANDOM: " .. rand)

    for i=0,rand do
        local index = getEmptySpot(room,true)
        if (index) then
            room[index] = 1
        end
    end
end

function clearLeftTwoSpots(room,index)
    local x = positionXFromArrayIndex(index) 
    local y = positionXFromArrayIndex(index) 
    local width = math.sqrt(#room)

    if (x-2 > 0) then
        local newIndex = indexFromCoordinates(x-2,y)
        if (room[newIndex] == 0) then
            newIndex = indexFromCoordinates(x-1,y)
            if (room[newIndex] == 0) then
                return true
            end
        end
    end
    return false
end

function clearRightTwoSpots(room,index)
    local x = positionXFromArrayIndex(index) 
    local y = positionXFromArrayIndex(index) 
    local width = math.sqrt(#room)

    if (x+2 < width) then
        local newIndex = indexFromCoordinates(x+2,y)
        if (room[newIndex] == 0) then
            newIndex = indexFromCoordinates(x+1,y)
            if (room[newIndex] == 0) then
                return true
            end
        end
    end
    return false
end

function clearDownTwoSpots(room,index)
    local x = positionXFromArrayIndex(index) 
    local y = positionXFromArrayIndex(index) 
    local height = math.sqrt(#room)

    if (y+2 < height) then
        local newIndex = indexFromCoordinates(x,y+2)
        if (room[newIndex] == 0) then
            newIndex = indexFromCoordinates(x,y+1)
            if (room[newIndex] == 0) then
                return true
            end
        end
    end
    return false
end

function clearUpTwoSpots(room,index)
    local x = positionXFromArrayIndex(index) 
    local y = positionXFromArrayIndex(index) 

    if (y > 2) then
        local newIndex = indexFromCoordinates(x,y-2)
        if (room[newIndex] == 0) then
            newIndex = indexFromCoordinates(x,y-1)
            if (room[newIndex] == 0) then
                return true
            end
        end
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
                    if (clearUpTwoSpots(room,rand) and clearDownTwoSpots(room,rand) and clearLeftTwoSpots(room,rand) and clearRightTwoSpots(room, rand)) then
                        return rand
                    end
                else
                    return rand
                end
            end
        end
        tries = tries - 1
    end
end

