function onCreatePost()
    --[[
    setProperty('healthBar.visible', false)
    ]]
    setProperty('healthBarBG.visible', false)
    setProperty('healthBarOverlay.visible', false)
    setProperty('camGame.visible', true)
    
    addLuaSprite('healthBarWithAnim', true)
    makeAnimatedLuaSprite('healthBarWithAnim', 'healthBarAnimated', 340, 640)
    addAnimationByPrefix('healthBarWithAnim', 'healthBarAnimated', 'Health Bar Animated', 24, true)

    if downscroll then
        setProperty('healthBarWithAnim.y', 80)
    end

    setObjectCamera('healthBarWithAnim', 'camHUD')
    setObjectOrder('healthBarWithAnim', getObjectOrder('healthBar')+1)
end
--[[
function onUpdate()
    if health == 2 then
        setProperty('healthBarWithAnim.visible', false)
    else
        setProperty('healthBarWithAnim.visible', true)
    end
end
]]