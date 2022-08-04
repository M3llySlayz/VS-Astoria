function onUpdate(elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    for i=0,7 do
        if currentBeat then
        triggerEvent('Add Camera Zoom', '0.05', '0.05');
        end
    end
end