player = {
    
    x = 2,
    y = 2,
    dir = 0,
    rot = 0,
    speed = 0,
    moveSpeed = 4,
    strafeSpeed = 0,
--  rotSpeed =  math.pi / 180 * 2,
--  mouseSpeed = (math.pi / 180 * 2)/12
    rotSpeed = 2,
    mouseSpeed = 0.05,
    bulletSpeed = 5.5
}

function convertPlayerRotation()
    player.rot = (player.rot % twoPI)
    if (player.rot < 0) then
        player.rot = player.rot + twoPI
    end
end

function setPlayerSpawnPoint()
    player.x = SPAWNPOINT.x
    player.y = SPAWNPOINT.y
end
