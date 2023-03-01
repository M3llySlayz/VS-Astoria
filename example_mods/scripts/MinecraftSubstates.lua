buttonArray = {} -- sprite groups rule!
scalething = 4
amIdead = false
curselect = 1

function onPause()
    if not getPropertyFromClass('PlayState', 'chartingMode') then
    openCustomSubstate('minecraftPause', true)
    return Function_Stop
    end
    return Function_Continue
end

--[[
function onGameOver()
    if not amIdead then
    setProperty('boyfriend.stunned', true)
    setProperty('playbackRate', 0) -- basiclly pauses the song
    openCustomSubstate('udied', false)
    amIdead = true
    end
    return Function_Stop
end
]]

function onCustomSubstateCreate(name)
    if name == 'minecraftPause' then
        initSaveData('options', 'nb2MCHUD')
        if getDataFromSave('options', 'screenRotate', true) == nil then 
            setDataFromSave('options', 'screenRotate', true)
        end
        if getDataFromSave('options', 'hurtSound', true) == nil then 
            setDataFromSave('options', 'hurtSound', true)
        end
        flushSaveData('options')

        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

        makeLuaSprite('Punderlay', '', 0, 0)
        makeGraphic('Punderlay', screenWidth, screenHeight, '000000')
        setObjectCamera('Punderlay', 'other')
        addLuaSprite('Punderlay', false)
        setProperty('Punderlay.alpha', 0.6)

        diffs = getPropertyFromClass('CoolUtil', 'difficulties')
        if #diffs > 1 then 
            cannotChangeDiff = false
        else
            cannotChangeDiff = true
        end

        makeButton('resume', 'Continue', 250, 140, false, 'other', 1)
        makeButton('restart', 'Retry', 250, 230, false, 'other', 0.5)
        makeButton('diff', 'Change Difficulty', 250, 320, cannotChangeDiff, 'other', 0.5)
        makeButton('optionsmenu', 'Options...', 250, 410, false, 'other', 0.5)
        makeButton('quit', 'Quit', 250, 500, false, 'other', 1)

        makeLuaText('pausename', 'Game Menu', screenWidth, 0, 50)
        setTextFont('pausename', 'Minecraftia.ttf')
        setTextSize('pausename', 24)
        setObjectCamera('pausename', 'other')
        addLuaText('pausename')
        screenCenter('pausename', 'x')
    end
    if name == 'diffchange' then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

        makeLuaSprite('Punderlay', '', 0, 0)
        makeGraphic('Punderlay', screenWidth, screenHeight, '000000')
        setObjectCamera('Punderlay', 'other')
        addLuaSprite('Punderlay', false)
        setProperty('Punderlay.alpha', 0.6)

        makeButton('pausething', 'Back', 250, 600, false, 'other', 0.25)
        makeButton('diffleft', '<-', 250, 340, false, 'other', 0.2)
        makeButton('diffselect', '', 450, 340, false, 'other', 0.5)
        makeButton('diffright', '->', 900, 340, false, 'other', 0.2)

        makeLuaText('diffname', 'NORMAL', screenWidth, 0, 350)
        setTextFont('diffname', 'Minecraftia.ttf')
        setTextSize('diffname', 24)
        setObjectCamera('diffname', 'other')
        addLuaText('diffname')
        screenCenter('diffname', 'x')

        makeLuaText('pausename', 'Change Difficulty', screenWidth, 0, 50)
        setTextFont('pausename', 'Minecraftia.ttf')
        setTextSize('pausename', 24)
        setObjectCamera('pausename', 'other')
        addLuaText('pausename')
        screenCenter('pausename', 'x')
    end
    if name == 'optionsmenu' then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

        makeLuaSprite('Punderlay', '', 0, 0)
        makeGraphic('Punderlay', screenWidth, screenHeight, '000000')
        setObjectCamera('Punderlay', 'other')
        addLuaSprite('Punderlay', false)
        setProperty('Punderlay.alpha', 0.6)

        --[[
        local screenRotate = getDataFromSave('options', 'screenRotate', true)
        makeButton('screenrotate', 'Screen Rotate on Miss: '..(screenRotate and 'ON' or 'OFF'), 250, 200, false, 'other', 1)
        local hurtSound = getDataFromSave('options', 'hurtSound', true)
        makeButton('hurtsound', 'Hurt Sound on Miss: '..(hurtSound and 'ON' or 'OFF'), 250, 280, false, 'other', 1)
        ]]
        makeButton('options', 'Psych Options...', 250, 410, false, 'other', 1)
        makeButton('pausething', 'Back', 250, 600, false, 'other', 0.25)

        makeLuaText('pausename', 'Options\n(OPTIONS REQUIRE RESTART!)', screenWidth, 0, 50)
        setTextFont('pausename', 'Minecraftia.ttf')
        setTextSize('pausename', 24)
        setObjectCamera('pausename', 'other')
        addLuaText('pausename')
        screenCenter('pausename', 'x')
    end

    --[[
        if name == 'udied' then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

        makeLuaSprite('Punderlay', '', 0, 0)
        makeGraphic('Punderlay', screenWidth, screenHeight, 'a80000')
        setObjectCamera('Punderlay', 'other')
        addLuaSprite('Punderlay', false)
        setProperty('Punderlay.alpha', 0.6)

        makeButton('restart', 'Respawn', 250, 300, false, 'other', 1)
        makeButton('quit', 'Title Screen', 250, 400, false, 'other', 1)

        makeLuaText('pausename', 'You Died!', screenWidth, 0, 100)
        setTextFont('pausename', 'Minecraftia.ttf')
        setTextSize('pausename', 40)
        setObjectCamera('pausename', 'other')
        addLuaText('pausename')
        screenCenter('pausename', 'x')

        extraSpaces = ' '
        for i = 1, string.len(tostring(score)) do 
            extraSpaces = extraSpaces..' '
        end

        makeLuaText('scoreshitty', 'Score: '..extraSpaces, screenWidth, 0, 200)
        setTextFont('scoreshitty', 'Minecraftia.ttf')
        setTextSize('scoreshitty', 20)
        setObjectCamera('scoreshitty', 'other')
        addLuaText('scoreshitty')
        screenCenter('scoreshitty', 'x')

        makeLuaText('scoreshitty2', '  '..extraSpaces..score, screenWidth, 0, 200)
        setTextFont('scoreshitty2', 'Minecraftia.ttf')
        setTextSize('scoreshitty2', 20)
        setObjectCamera('scoreshitty2', 'other')
        addLuaText('scoreshitty2')
        screenCenter('scoreshitty2', 'x')
        setTextColor('scoreshitty2', 'f6ff00')
    end
    ]]
end

function onCustomSubstateUpdate(name, elapsed)
    if name == 'minecraftPause'then
        buttonShit()
    end
    --[[
    if name == 'udied' then
        buttonShit()
    end
    ]]
    if name == 'optionsmenu' then
        buttonShit()
    end
    if name == 'diffchange' then
        setTextString('diffname', diffs[curselect])
        buttonShit()
    end
end

function onCustomSubstateDestroy(name)
    if name == 'minecraftPause' then
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
    removeLuaSprite('Punderlay', false)
    removeLuaText('diffname', false)
    removeLuaText('pausename', false)
    destroyButtons()
    end
    if name == 'diffchange' then
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
    removeLuaText('diffname', false)
    removeLuaSprite('Punderlay', false)
    removeLuaText('pausename', false)
    destroyButtons()
    end
end


function makeButton(tag, text, x, y, unselectable, camera, scalex)
    -- button
    makeAnimatedLuaSprite('button-'..tag, 'button', x, y)
    addAnimationByPrefix('button-'..tag, 'blank', 'button blank', 24, true)
    addAnimationByPrefix('button-'..tag, 'normal', 'button normal', 24, true)
    addAnimationByPrefix('button-'..tag, 'selected', 'button selected', 24, true)
    scaleObject('button-'..tag, scalex * scalething, scalething)
    setProperty('button-'..tag..'.antialiasing', false)
    setObjectCamera('button-'..tag, camera)
    addLuaSprite('button-'..tag, true)
    if unselectable then 
        playAnim('button-'..tag, 'blank', true)
    else
        playAnim('button-'..tag, 'normal', true)
    end
    updateHitbox('button-'..tag)

    -- text 
    local iammid = betterCenter(x, y, x + (200*scalething)*scalex, y + (20*scalething)) -- stop.
    makeLuaText('button-'..tag..'-text', text, screenWidth, iammid[1] - (screenWidth/2), iammid[2] - 5*scalething)
    setTextFont('button-'..tag..'-text', 'Minecraftia.ttf')
    setTextSize('button-'..tag..'-text', 26)
    setTextAlignment('button-'..tag..'-text', 'center')
    setObjectCamera('button-'..tag..'-text', camera)
    addLuaText('button-'..tag..'-text')

    buttonArray[#buttonArray + 1] = {'button-'..tag, unselectable, scalex}
end

function destroyButtons()
    for i = 1, #buttonArray do 
        removeLuaSprite(buttonArray[i][1], false)
        removeLuaText(buttonArray[i][1]..'-text', false)
    end
    buttonArray = {}
end

function buttonShit()
    for i = 1, #buttonArray do -- reused code :skull:
    if not buttonArray[i][2] then
        if getMouseX('other') >= getProperty(buttonArray[i][1]..'.x') and getMouseX('other') <= getProperty(buttonArray[i][1]..'.x') + (200*scalething)*(buttonArray[i][3]) and getMouseY('other') >= getProperty(buttonArray[i][1]..'.y') and getMouseY('other') <= getProperty(buttonArray[i][1]..'.y') + 20*scalething then
            playAnim(buttonArray[i][1], 'selected', true)
            if mouseClicked() then
                playSound('click', 1, 'clicky')
                onMCButtonClick(buttonArray[i][1])
            end
        else 
            playAnim(buttonArray[i][1], 'normal', true)
        end
    end
    end
end

function onMCButtonClick(buttontag)
    if buttontag == 'button-resume' then 
        closeCustomSubstate()
    end
    if buttontag == 'button-quit' then 
        exitSong(false)
    end
    if buttontag == 'button-pausething' then
        openCustomSubstate('minecraftPause', true)
    end
    if buttontag == 'button-restart' then 
        restartSong(false)
    end
    if buttontag == 'button-diff' then
        closeCustomSubstate()
        destroyButtons()
        openCustomSubstate('diffchange', true)
    end
    if buttontag == 'button-options' then 
        addHaxeLibrary('LoadingState')
        runHaxeCode([[
            LoadingState.loadAndSwitchState(new options.PauseOptionsState());
        ]])
    end
    if buttontag == 'button-optionsmenu' then 
        closeCustomSubstate()
        destroyButtons()
        openCustomSubstate('optionsmenu', true)        
    end
    if buttontag == 'button-advance' then 
        addHaxeLibrary('MusicBeatState')
        runHaxeCode([[
            MusicBeatState.switchState(new AchievementsMenuState());
        ]])
    end
    if buttontag == 'button-psychdisco' then 
        os.execute("start https://discord.gg/2ka77eMXDv") -- psych discord!
    end
    if buttontag == 'button-diffleft' then 
        curselect = ((curselect == 1) and #diffs or curselect - 1)
    end
    if buttontag == 'button-diffright' then 
        curselect = ((curselect == #diffs) and 1 or curselect + 1)
    end
    if buttontag == 'button-diffselect' then 
        loadSong(songName, curselect - 1)
    end
    if buttontag == 'button-screenrotate' then 
        if getDataFromSave('options', 'screenRotate', true) then 
            setDataFromSave('options', 'screenRotate', false)
        else
            setDataFromSave('options', 'screenRotate', true)
        end
        setTextString('button-screenrotate-text', 'Screen Rotate on Miss: '..(getDataFromSave('options', 'screenRotate', true) and 'ON' or 'OFF'))
    end
    if buttontag == 'button-hurtsound' then 
        if getDataFromSave('options', 'hurtSound', true) then 
            setDataFromSave('options', 'hurtSound', false)
        else
            setDataFromSave('options', 'hurtSound', true)
        end
        setTextString('button-hurtsound-text', 'Hurt Sound on Miss: '..(getDataFromSave('options', 'hurtSound', true) and 'ON' or 'OFF'))
    end
end

function betterCenter(x1, y1, x2, y2) -- ( (x1 + x2) / 2, (y1 + y2) / 2 )
    local centerX = (x1 + x2) / 2
    local centerY = (y1 + y2) / 2 
    return {centerX, centerY}
end