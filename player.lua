player = {
    level = 0,    
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
    objType = "player",
    id = 0,
    hit = false,
    hitDecay = 10,
    health = 8,
    
    primary = 1,
    secondary = 13,
    secondaryRecharge = true,
    bulletSpeed = 5.5,
    bulletImg = 1,
    fireDmg = 1,

    maxFireRate = 0.5, 
    fireRate = 0,
    fireSecondaryRate = 0,
    firing = false,

    tripleShot = false,

    roastMax = 2,
    roastNumber = 4
}


defaultPlayer = {
    level = 0,    
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
    objType = "player",
    id = 0,
    hit = false,
    hitDecay = 10,
    health = 8,
    
    primary = 1,
    secondary = 13,
    secondaryRecharge = true,
    bulletSpeed = 5.5,
    bulletImg = 1,
    fireDmg = 1,

    maxFireRate = 0.5, 
    fireRate = 0,
    fireSecondaryRate = 0,
    firing = false,

    tripleShot = false,

    roastMax = 2,
    roastNumber = 4
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

function playerHitDraw()
    player.hit = true
end

function firePlayerWeapon(dt)
    if (player.firing) then
        if (player.fireRate < 0) then
            createBullet(player,player.tripleShot)
            player.fireRate = player.maxFireRate
        else
            player.fireRate = player.fireRate - dt 
        end
    end
    if (player.secondFiring and player.secondaryRecharge) then
        if (player.fireSecondaryRate < 0) then
            player.fireSecondaryRate = player.maxFireRate
            fireSecondary()
        else
            player.fireSecondaryRate = player.fireSecondaryRate - dt * SECONDARY_RATES[player.secondary] 
        end
    end
end

function fireSecondary()
    local action = SECONDARY[player.secondary]    
    action()
end
