roomSize = 0

function createRoom()
    local size = 20
    local room = createEmptyRoom(size)
    printGeneratedRoom(room)
    print(#room)


    addDoorTop(room,true)
    addDoorBottom(room,true)
    addDoorRight(room,true)
    addDoorLeft(room,true)
    addObstacles(room)
    printGeneratedRoom(room)

    loadMapFromRoom(room) 
    local spawn = getEmptySpot(room)
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
    local rand = math.random(10,15)
    print ("THIS IS RANDOM: " .. rand)

    for i=0,rand do
        local index = getEmptySpot(room)
        room[index] = 1
    end
end

function getEmptySpot(room)
    local size = #room 
    local roomSizeRoot = math.sqrt(size) 
    local success = true 

    while (success) do
        local rand = math.random(roomSizeRoot*2,size-(roomSizeRoot*2)) 
        if (rand % roomSizeRoot > 2 and rand / roomSizeRoot < roomSizeRoot-2) then
            if (room[rand] == 0) then 
                return rand
            end
        end
    end
end
