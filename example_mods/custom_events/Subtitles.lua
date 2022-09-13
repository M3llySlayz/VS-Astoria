-- Event notes hooks

function onEvent(name, value1, value2)
	if name == 'Subtitles' then
         setTextString('subtitle', value1)
         setTextColor('subtitle', value2)
	end
end


function onCreate()
    fade = 0
    makeLuaText('subtitle', '', 400, 445, 500)
    addLuaText('subtitle')
    setTextSize('subtitle', 60)
end