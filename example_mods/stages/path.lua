function onCreate()
    setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-pixel-dead');

    makeLuaSprite('LQbg', 'path/bg', -700, 0);
    makeLuaSprite('bg', 'path/pathmap', -625, 15);

    scaleObject('LQbg', 5, 5);
    scaleObject ('bg', 1.2, 1.5);

    addLuaSprite('LQbg', false);
    addLuaSprite('bg', false);
end

function onCreatePost()
    if lowQuality then
        setProperty('bg.visible', false)
        elseif not lowQuality then
        setProperty('LQbg.visible', false)
    end
end