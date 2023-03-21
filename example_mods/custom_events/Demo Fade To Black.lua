function onCreate()
    makeLuaSprite('black', 'stages/black', 0, 0);
    makeGraphic('black', 1280, 720, 000000);
    addLuaSprite('black', true);
    setLuaSpriteScrollFactor('black',0,0)
	setProperty('black.scale.x',2)
	setProperty('black.scale.y',2)
    setObjectCamera('black', 'other');

    setProperty('black.alpha', 0.0001); --making it this arbitrary number reduces lag when it's created
end

function onEvent(n, v1)
    if n == 'Demo Fade To Black' then
        setProperty('black.alpha', 0.1)
        doTweenAlpha('demoEnd', 'black', 1, v1, 'linear');
    end
end