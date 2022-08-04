function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Star Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Star Note' then
			if lowQuality then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'stars/star_notes'); --Change texture
			else
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'stars/star_notesHQ');
			end
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', 0.5); --Change amount of health to take when you miss
		end
	end
end
function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Star Note' then
		setProperty('dad.specialAnim', true);

		local animToPlay = '';
		if noteData == 0 then
			animToPlay = 'playLeft';
		elseif noteData == 1 then
			animToPlay = 'playDown';
		elseif noteData == 2 then
			animToPlay = 'playUp';
		elseif noteData == 3 then
			animToPlay = 'playRight';
		end
		characterPlayAnim('dad', animToPlay, true);
		health = getProperty('health')
		if getProperty('health') > 0.1 then
			setProperty('health', health- 0.030);
			end
		end
	end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Star Note' then
		local animToPlay = '';
		if not isSustainNote then
		playSound('slice', 1.1);
		end
		if noteData == 0 then
			animToPlay = 'attackLR';
		elseif noteData == 1 then
			animToPlay = 'attackUD';
		elseif noteData == 2 then
			animToPlay = 'attackUD';
		elseif noteData == 3 then
			animToPlay = 'attackLR';
		end
		if boyfriendName == 'AM-New-Playable' then
			setProperty('boyfriend.specialAnim', true);
			characterPlayAnim('bf', animToPlay, true);
		else if boyfriendName =='bf' then
			setProperty('boyfriend.specialAnim', true);
			characterPlayAnim('bf', 'attack', true);
			end
		end
	end
end