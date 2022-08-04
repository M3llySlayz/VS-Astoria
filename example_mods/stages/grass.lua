function onCreate()
    setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-pixel-dead');
    makeLuaSprite('sky', 'grass/sky', -750, -200);
    makeLuaSprite('grass', 'grass/grass', -750, -200);
    makeLuaSprite('sun', 'grass/sun', -750, -200);
    makeLuaSprite('sky2', 'grass/sky', -750, -500);
    makeLuaSprite('grassunder', 'grass/grassunder', -750, 1000);
    makeLuaSprite('newbg', 'grass/map', -600, 100);
    makeLuaSprite('newbg2', 'grass/mapsky', -600, -600)

    scaleObject('sky', 5, 5);
    scaleObject('sky2', 5, 5);
    scaleObject('grass', 5, 5);
    scaleObject('sun', 5, 5);
    scaleObject('grassunder', 5, 5);
    scaleObject('newbg', 1.2, 1);
    scaleObject('newbg2', 1.2, 1)

    addLuaSprite('sky', false);
    addLuaSprite('sky2', false);
    addLuaSprite('grass', false);
    addLuaSprite('grassunder', false);
    addLuaSprite('sun', false);
    addLuaSprite('newbg2', false)
    addLuaSprite('newbg', false);
end
    --this caused me multiple days of pain
function onCreatePost()
    if lowQuality then
        setProperty('newbg.visible', false)
        setProperty('newbg2.visible', false)
    elseif not lowQuality then
        setProperty('sky.visible', false)
        setProperty('sky2.visible', false)
        setProperty('grassunder.visible', false)
        setProperty('grass.visible', false)
        setProperty('sun.visible', false)
    end
end