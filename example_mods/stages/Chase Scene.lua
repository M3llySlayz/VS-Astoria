function onCreate()
    setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-pixel-dead');

    --low quality things
    makeLuaSprite('LQbg', 'chase scene/sky', -700, 275);
    makeLuaSprite('LQbuildings', 'chase scene/buildings', -250, 200);
    makeLuaSprite('LQground', 'chase scene/actual grass', -600, 350);
    makeAnimatedLuaSprite('LQpath', 'chase scene/path', -525, 350);
    makeAnimatedLuaSprite('LQgrass', 'chase scene/trees and grass', -850, 275);
    makeLuaSprite('LQclouds', 'chase scene/clouds', -200, -200);
    makeAnimatedLuaSprite('LQrain', 'city path/Rain', -625, 275);
    makeLuaSprite('dark', '', -625, 275);

    --darkness because who needs pngs
    makeGraphic('dark', 640, 360, 000000);

    addAnimationByPrefix('LQgrass', 'idle', 'Tree Idle', 12, true);
    addAnimationByPrefix('LQpath', 'idle', 'Path Idle', 12, true);
    addAnimationByPrefix('LQrain', 'idle', 'CP Idle', 24, true);

    scaleObject('LQbg', 5, 5);
    scaleObject('LQbuildings', 2.7, 2.7);
    scaleObject('LQground', 3, 2.7);
    scaleObject('LQgrass', 4.5, 3);
    scaleObject('LQpath', 3, 2.7);
    scaleObject('LQclouds', 2.7, 2.7);
    scaleObject('LQrain', 3.5, 4);
    scaleObject('dark', 3.5, 4);
    
    objectPlayAnimation('LQgrass', 'idle', true);
    objectPlayAnimation('LQpath', 'idle', true);
    objectPlayAnimation('LQrain', 'idle', true);

    setScrollFactor('LQbuildings', 0.3, 0.5);
    setScrollFactor('LQclouds', 0.4, 0.2);

    addLuaSprite('LQbg', false);
    addLuaSprite('LQbuildings', false);
    addLuaSprite('LQground', false);
    addLuaSprite('LQpath', false)
    addLuaSprite('LQgrass', true);
    addLuaSprite('LQclouds', true);
    addLuaSprite('LQrain', true);
    addLuaSprite('dark', true);
    
    setProperty('dark.alpha', 0.4);
    setProperty('LQbg.antialiasing', false);

    --[[
    --high quality things
    makeAnimatedLuaSprite('bg', 'city path/City Path Good', -625, 50);
    makeAnimatedLuaSprite('rain', 'city path/Rain Good', -625, 50);

    addAnimationByPrefix('bg', 'idle', 'CP Idle', 8, true);
    addAnimationByPrefix('rain', 'idle', 'CP Idle', 15, true);

    scaleObject('bg', 3.5, 4);
    scaleObject('rain', 3.5, 4);

    objectPlayAnimation('bg', 'idle', true);
    objectPlayAnimation('rain', 'idle', true);

    addLuaSprite('bg', false);
    addLuaSprite('rain', true);

    setProperty('bg.antialiasing', false);]]
end

--[[
function onCreatePost()
    if lowQuality then
        setProperty('bg.visible', false);
        setProperty('rain.visible', false);
    elseif not lowQuality then
        setProperty('LQbg.visible', false)
        setProperty('LQrain.visible', false)
    end
end
]]

function onBeatHit()
	-- triggered 4 times per section
	if curBeat % 2 == 0 then
		objectPlayAnimation('LQrain', 'idle', true);
        objectPlayAnimation('LQpath', 'idle', true);
        objectPlayAnimation('LQgrass', 'idle', true);
        --objectPlayAnimation('bg', 'idle', true);
        --objectPlayAnimation('rain', 'idle', true);
	end
end