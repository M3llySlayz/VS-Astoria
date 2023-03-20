
function onUpdate()
    local health = getProperty('health')
    if health >= 2 then
        setProperty('healthBar.visible', false);
        setProperty('healthBarOverlay.visible', false);
        setProperty('healthBarBG.visible', false);
        setProperty('healthBarWithAnim.visible', false);
        setProperty('iconP1.visible', false);
        setProperty('iconP2.visible', false);
        setProperty('scoreTxt.x', -300)
    else
        setProperty('healthBar.visible', true);
       --[[ setProperty('healthBarOverlay.visible', true);
        setProperty('healthBarBG.visible', true);]]
        setProperty('healthBarWithAnim.visible', true);
        setProperty('iconP1.visible', true);
        setProperty('iconP2.visible', true);
        setProperty('scoreTxt.x', 0)
    end
end
-- that took way too long