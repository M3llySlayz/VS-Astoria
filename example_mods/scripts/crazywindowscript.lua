songended = false

function onUpdatePost()
    if songended == false then
    setPropertyFromClass('lime.app.Application', 'current.window.title', 'VS Astoria | '..'Song: '..getProperty('curSong')..' | '..getProperty('scoreTxt.text'))
    end
end
function onDestroy()
    songended = true
    setPropertyFromClass('lime.app.Application', 'current.window.title', 'VS Astoria')
end

function onGameOver()
    songended = true
    setPropertyFromClass('lime.app.Application', 'current.window.title', 'VS Astoria'..' Song: '..getProperty('curSong')..' | You Died!')
    return Function_Continue
end