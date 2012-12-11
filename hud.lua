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
