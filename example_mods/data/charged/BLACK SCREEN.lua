--ty to Seek's Deltarune Mod
function onCreate()
    makeLuaSprite('dark2', 'thedarkness', -700, -100);
    addLuaSprite('dark2', true);
    scaleObject('dark2', 5, 5)
end

local boobs = true;

function onSongStart()
    if boobs == true then
        doTweenAlpha('dark2', 'dark2', 0, 16);
    end
end