--thanks to Nami so 95 for making this!
function onStepHit()
    if curStep == 256 then
        started = true
    end

    songPos = getSongPosition()

    local currentBeat = (songPos/5000)*(curBpm/60)

    if started == true then
        doTweenY('opponentmove', 'dad', 0 - 25*math.sin((currentBeat+12*12)*math.pi) + 400, 2)
        doTweenX('disruptor2', 'disruptor2.scale', 0 - 50*math.sin((currentBeat+1*0.1)*math.pi), 6)
        doTweenY('disruptor2', 'disruptor2.scale', 0 - 31*math.sin((currentBeat+1*1)*math.pi), 6)
    end
end