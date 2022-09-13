--By: BlueColorsin's Shitty Scripts production--
--Simple Splitscroll Script--

local BarConfig = {0, -20}
function onCreatePost()
    if getPropertyFromClass('ClientPrefs', 'splitScroll') == true then
    -- if downscroll == false then 
        if not downscroll then
            for i = 0,1 do  
                setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                setPropertyFromGroup('playerStrums',i,'downScroll',true) 
            end
            BarConfig = {706, 620}
        else -- if downscroll == true then
            for i = 2,3 do 
                setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                setPropertyFromGroup('playerStrums',i,'downScroll',false)
            end
        end
            -- Icon Shit
        setProperty('iconP1.y', BarConfig[2]) --sets both of the icons too there value
        setProperty('iconP2.y', BarConfig[2])
        setProperty('scoreTxt.y', BarConfig[1]) -- scoreTxt out of the way :D
        setProperty('healthBar.y', BarConfig[1]) -- as you can tell this is setProperty abuse
        setProperty('healthBarOverlay.y', BarConfig[1])
    end
end