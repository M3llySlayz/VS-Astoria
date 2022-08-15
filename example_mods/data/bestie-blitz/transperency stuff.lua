function onCreate()
    triggerEvent('MoveArrow', 0, '0, 0, 0, 0, 0.1');
    triggerEvent('MoveArrow', 1, '0, 0, 0, 0, 0.1');
    triggerEvent('MoveArrow', 2, '0, 0, 0, 0, 0.1');
    triggerEvent('MoveArrow', 3, '0, 0, 0, 0, 0.1');
    setProperty('iconP2.alpha', 0);
    setProperty('dad.alpha', 0);
end

function onStepHit()
    if curStep == 112 then
        doTweenAlpha('Icon Tween', 'iconP2', 1, 2, 'linear');
        doTweenAlpha('AM Tween', 'dad', 1, 2, 'linear');
    end
end