function getDirectionInString()
    local compass = ""
    if (player.rot < ((3*3.14)/4) and player.rot > (3.14/4)) then
        compass = "S"
    end
    if (player.rot > ((5*3.14)/4) and player.rot < ((7*3.14)/4)) then
        compass = "N"
    end
    if (player.rot < ((5*3.14)/4) and player.rot > ((3*3.14)/4)) then
        compass = "W"
    end
    if (player.rot > ((7*3.14)/4) or player.rot < ((3.14)/4)) then
        compass = "E"
    end
    return compass
end

function drawHud()
    drawHearts()
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(hudImg,0,375,0)   
    love.graphics.setFont(mainFont)
    love.graphics.print(getDirectionInString(), 142, 432)
    drawPrimary()
    drawSecondary()
    drawBossLife()
end

function drawHearts()
    love.graphics.setColor(255,0,0,255)
    if (player.health > -0.5 and player.health < 0) then
        love.graphics.rectangle("fill",218,455,25/2,22)
    else
        for i=0, player.health,0.5 do
            love.graphics.rectangle("fill",218+(i*25),455,25,22)
        end
    end
end

function drawPrimary()
    local weapon = player.primary
    local quad = SPRITEQUAD[4][weapon]
    love.graphics.drawq(wallsImgs,quad,440,390,0,2,2)
end
    
function drawSecondary()
    if (player.secondary == nil) then
        return
    end
    local weapon = player.secondary
    local quad = SPRITEQUAD[2][weapon]
    if not(player.secondaryRecharge) then
        love.graphics.setColor(100,100,100,205)
    end
    love.graphics.drawq(wallsImgs,quad,530,390,0,2,2)
end

function loadHud()
    hudImg = love.graphics.newImage("hud.png")
    mainFont = love.graphics.newFont(35)
    healthBarRatio = 0
end

function setupBossLife(sprite)
    maxBossHealth = sprite.health
    healthBarRatio = 200/maxBossHealth
end

function drawBossLife()
    if (SPRITES[1]) then
        if (SPRITES[1].boss) then
            local health = SPRITES[1].health
            local bossLifeBar = health*healthBarRatio
            love.graphics.setColor(255,0,0,255)
            love.graphics.rectangle("fill",218,25,bossLifeBar,12)
        end
    end
end
