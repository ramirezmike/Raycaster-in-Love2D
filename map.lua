mapProp = {
    tileSize = 64,
    mapWidth = 0,
    mapHeight = 0,
    miniMapScale = 6,
    displayMap = false,
    map = {}
}

function saveMapToDisk(map)
    local mapString = "map = {"  
    for i = 1, #map - 1 do
        mapString = mapString .. tostring(map[i]) .. ","
    end
    mapString = mapString .. tostring(map[#map]) .. "} \n return map"

    local file = (io.open("map02.lua", "w"))
    file:write(mapString)
    file:close()
end

function loadMapFromDisk()
    chunk = love.filesystem.load( "map01.lua") 
    mapProp.map = chunk()
    mapProp.mapWidth =  (math.sqrt(table.getn(map)))
    mapProp.mapHeight = (math.sqrt(table.getn(map)))
end
