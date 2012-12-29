introDelay = 0
introScreen = 1
INTRO_TEXT = {
    [1] = "'Santa Claus isn't real.'", 
    [2] = 2,
    [3] = "That's what they tell us.",
    [4] = 3,
    [5] = "This lie makes us do his work",
    [6] = 3,
    [7] = "while he profits from the season.",
    [8] = 3,
    [9] = "It's time to remind him what Christmas is about.",
    [10] = 3,
}

function drawIntro()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",0,0,screenWidth,screenHeight)
    love.graphics.setColor(255,255,255)
    love.graphics.printf(INTRO_TEXT[introScreen],0,screenHeight/2,screenWidth,'center') 
end

function introManagement(dt)
    introDelay = introDelay + dt
    if (introDelay > INTRO_TEXT[introScreen+1]) then
        introDelay = 0
        introScreen = introScreen + 2
    end
    if (introScreen > #INTRO_TEXT) then
        introDisplaying = false
        return
    end
end

