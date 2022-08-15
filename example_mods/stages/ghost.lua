function onCreate()
    makeLuaSprite('bg', 'stages/bg', -70, -130);

    scaleObject('bg', 2.5, 2.5);

    setProperty('bg.antialiasing', false)

    addLuaSprite('bg', false);
end