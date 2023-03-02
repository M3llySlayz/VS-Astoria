function onUpdate()
    if boyfriendName == 'bf-pixel' then
    else
    if boyfriendName == 'bf-sus' then
    else
      for i=0,4,1 do
       setPropertyFromGroup('opponentStrums', i, 'texture', 'white')
             setPropertyFromGroup('opponentStrums', i, 'color', getIconColor('dad'))
    end
    for i = 0, getProperty('unspawnNotes.length')-1 do
                if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'GF Sing' then
                        setPropertyFromGroup('unspawnNotes', i, 'color', getIconColor('gf'))
		        setPropertyFromGroup('unspawnNotes', i, 'texture', 'white');
                else
		if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                        setPropertyFromGroup('unspawnNotes', i, 'color', getIconColor('dad'))
		        setPropertyFromGroup('unspawnNotes', i, 'texture', 'white');
                end
                end
        end
    setTextFont('rating', 'In your face, joffrey!.ttf');
    setTextFont('misses', 'In your face, joffrey!.ttf');
    setTextFont('score', 'In your face, joffrey!.ttf');
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