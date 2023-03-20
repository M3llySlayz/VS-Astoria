local songended = false
local dont
function onCreate()
    if songName == 'Shop' then
    dont = true
    end
end
if dont ~= true then
    function onUpdatePost()
        if songended == false then
        setPropertyFromClass('lime.app.Application', 'current.window.title', 'VS Astoria Demo | '..'Song: '..getProperty('curSong')..' | '..getProperty('scoreTxt.text'))
        end
    end
    function onDestroy()
       songended = true
      setPropertyFromClass('lime.app.Application', 'current.window.title', 'VS Astoria Demo')
    end

    function onGameOver()
        songended = true
        setPropertyFromClass('lime.app.Application', 'current.window.title', 'VS Astoria Demo |'..' Song: '..getProperty('curSong')..' | You Died!')
        return Function_Continue
    end
end