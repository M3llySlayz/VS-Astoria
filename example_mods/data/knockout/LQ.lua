function onCreate()
    if lowQuality then
        triggerEvent('Change Character', 1, 'SG')
        triggerEvent('Change Character', 0, 'AM-Playable')
        setPropertyFromClass('GameOverSubstate', 'characterName', 'AM-Playable')
    else
        setPropertyFromClass('GameOverSubstate', 'characterName', 'AM-New-Dead')
    end
end