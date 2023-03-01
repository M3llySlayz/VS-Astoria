function onCreate()
	--Poggers
	if songName ~= 'Shuriken Fight' then
		precacheSound('slice');
	end
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Shuriken
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'shuriken' then
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.3); --Change amount of health to take when you miss
			if lowQuality then
				setPropertyFromGroup('unspawnNotes', i, 'texture', 'shurikens/sword_notesLQ');
			else
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'shurikens/sword_notes'); --Change png and xml the notes use
			end
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'shurikens/slash');
		end
	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'shuriken' then
		setProperty('dad.specialAnim', true);
			local dodge = '';
			if noteData == 0 then
				--if the Left note is hit by you then
				dodge = 'dodgeLeft';
				--play this animation
			elseif noteData == 1 then
				--else if the down note is hit by you
				dodge = 'dodgeDown';
				--play this, and so on
			elseif noteData == 2 then
				dodge = 'dodgeUp';
			elseif noteData == 3 then
				dodge = 'dodgeRight';
		end
		local animToPlay = '';
		if noteData == 0 then
			--if the Left note is hit by you then
			animToPlay = 'sliceLeft';
			--play this animation
		elseif noteData == 1 then
			--else if the down note is hit by you
			animToPlay = 'sliceDown';
			--play this, and so on
		elseif noteData == 2 then
			animToPlay = 'sliceUp';
		elseif noteData == 3 then
			animToPlay = 'sliceRight';
		end

		characterPlayAnim('dad', animToPlay, true);
		if boyfriendName == 'AM-Playable' or boyfriendName == 'AM-New-Playable' then
			characterPlayAnim('bf', dodge, true);
		elseif boyfriendName == 'bf-dark' or boyfriendName == 'bf-pixel' then
			characterPlayAnim('bf', 'dodge', true);
		end
		if songName == 'Shuriken Fight' or isSustainNote then
			--pick a random number for the variable
			blockSound = getRandomInt(0, 4);
			--now based on that, play a sound corresponding to it
			if blockSound == 0 then
				playSound('block1', 0.7);
			elseif blockSound == 1 then
				playSound('block2', 0.7);
			elseif blockSound == 2 then
				playSound('block3', 0.7);
			elseif blockSound == 3 then
				playSound('block4', 0.7);
			elseif blockSound == 4 then
				playSound('block5', 0.7);
			end
	else
		playSound('slice', 1.1);
		end
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'shuriken' then --if you miss a note then
		setProperty('dad.specialAnim', true);
		characterPlayAnim('dad', animToPlay, true); --use the code from before to play anims
		if boyfriendName == 'AM-New-Playable' then
			characterPlayAnim('bf', 'hurt', true);
		end
		playSound('hit', 0.5); --plus play this sound to tell you to not get hit lol
	end
end