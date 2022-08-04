function onEvent(n, v1, v2)
    if n == 'Hud Tween' then
        doTweenAlpha('alpha', 'camHUD', tonumber(v1), tonumber(v2), 'linear')
    end
end