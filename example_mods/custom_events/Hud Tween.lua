function onEvent(n, v1, v2)
    if n == 'Hud Tween' then
        doTweenAlpha('alpha', 'camHUD', v2, v1, 'linear')
    end
end