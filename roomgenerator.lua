roomSize = 0

function createRoom()
    local size = 11
    local room = createEmptyRoom(size)
    printGeneratedRoom(room)
    print(#room)

    mapProp.map = room   
    mapProp.mapWidth =  (size)
    mapProp.mapHeight = (size)
    
    player.x = 4
    player.y = 4

    addDoorTop(room)
    printGeneratedRoom(room)
    addDoorBottom(room)
    printGeneratedRoom(room)
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

function addDoorTop(room)
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=roomSizeRoot+1,roomSizeRoot*2 do
        room[i] = 3
    end

    local opening = roomSizeRoot + middle
    room[opening] = 0
end

function addDoorBottom(room)
    local size = #room
    local roomSizeRoot = math.sqrt(size)    

    local middle = math.ceil(roomSizeRoot / 2)
    for i=1+size-(roomSizeRoot*2),size-roomSizeRoot do
        room[i] = 2
    end

    local opening = size - roomSizeRoot - middle + 1
    room[opening] = 0
end
