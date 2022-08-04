function onCountdownTick(counter)
    if counter == 0 then
    triggerEvent('Flash Camera', 0.3, 'ff0000')
    end
    if counter == 1 then
    triggerEvent('Flash Camera', 0.3, 'ff0000')
    end
    if counter == 2 then
    triggerEvent('Flash Camera', 0.3, 'ffff00')
    end
    if counter == 3 then
    triggerEvent('Flash Camera', 0.3, '00ff00')
    end
end