local chararrows

function onCreate()
    if dadName == 'AM' or dadName == 'AM-New' or dadName == 'AM-Newer' then
        chararrows = 'AM'
    elseif dadName == 'AM-Red' or dadName == 'AM-Red-New' then
        chararrows = 'AMR'
    elseif dadName == 'AMM' then
        chararrows = 'AMM'
    elseif dadName == 'Brittany' or dadName == 'Brittany-New' or dadName == 'Brittany-Newer' then
        chararrows = 'Brit'
    elseif dadName == 'Voltage' or 'Voltage-New' then
        chararrows = 'Volt'
    elseif dadName == 'Donut-Man' or 'Donut-Man-New' then
        chararrows = 'Donut'
    elseif dadName == 'SG' or dadName == 'SG-New' or dadName == 'SG-Newer' then
        chararrows = 'SG'
    end
end

function onUpdate()
    --if boyfriendName == 'bf-pixel' then
    --else
    --if boyfriendName == 'bf-sus' then
    --else
      for i=0,4,1 do
        if getPropertyFromClass('ClientPrefs', 'opponentArrows') == 'Noteskinned' then
            setPropertyFromGroup('opponentStrums', i, 'texture', 'arrowskins/'..chararrows..'Notes')
        elseif getPropertyFromClass('ClientPrefs', 'opponentArrows') == 'Note Colors' then
            if getPropertyFromClass('ClientPrefs', 'noteSkin') == 'Circles' then
                setPropertyFromGroup('opponentStrums', i, 'texture', 'White_Circles')
            elseif getPropertyFromClass('ClientPrefs', 'noteSkin') == 'Arrows' then
                setPropertyFromGroup('opponentStrums', i, 'texture', 'white')
            end
            setPropertyFromGroup('opponentStrums', i, 'color', getIconColor('dad'))
        end
    end
    for i = 0, getProperty('unspawnNotes.length')-1 do
                if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'GF Sing' then
                        setPropertyFromGroup('unspawnNotes', i, 'color', getIconColor('gf'))
		        setPropertyFromGroup('unspawnNotes', i, 'texture', 'white');
                else
		if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            if getPropertyFromClass('ClientPrefs', 'opponentArrows') == 'Note Colors' then
                    setPropertyFromGroup('unspawnNotes', i, 'color', getIconColor('dad'))
                        if getPropertyFromClass('ClientPrefs', 'noteSkin') == 'Circles' then
                            setPropertyFromGroup('unspawnNotes', i, 'texture', 'White_Circles')
                        elseif getPropertyFromClass('ClientPrefs', 'noteSkin') == 'Arrows' then
                            setPropertyFromGroup('unspawnNotes', i, 'texture', 'white')
                        end
                    elseif getPropertyFromClass('ClientPrefs', 'opponentArrows') == 'Noteskinned' then
                        setPropertyFromGroup('unspawnNotes', i, 'texture', 'arrowskins/'..chararrows..'Notes')
                    end
            end
        end
    end
end

function getIconColor(chr)
	local chr = chr or "dad"
	return getColorFromHex(rgbToHex(getProperty(chr .. ".healthColorArray")))
end

function rgbToHex(array)
	return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end