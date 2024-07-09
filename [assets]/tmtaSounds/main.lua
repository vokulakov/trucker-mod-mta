Sounds = {}

Sounds.created = {}
Sounds.list = Config.SOUND_LIST

function Sounds.play(name, ...)
	local soundUrl = Sounds.list[name]
	if type(name) ~= "string" or not soundUrl then
		return false
	end

	local sound = Sound(soundUrl, ...)

	if sourceResource then
		if not Sounds.created[sourceResource] then
			Sounds.created[sourceResource] = {}
		end
		table.insert(Sounds.created[sourceResource], sound)
	end

	return sound
end

function Sounds.play3D(name, ...)
	local soundUrl = Sounds.list[name]
	if type(name) ~= "string" or not soundUrl then
		return false
	end

	local sound = Sound3D(soundUrl, ...)

	if sourceResource then
		if not Sounds.created[sourceResource] then
			Sounds.created[sourceResource] = {}
		end
		table.insert(Sounds.created[sourceResource], sound)
	end

	return sound
end

addEventHandler("onClientResourceStop", root,
	function(stoppedRes)
		local sounds = Sounds.created[stoppedRes]
		if not sounds then
			return
		end

		for _, sound in ipairs(sounds) do
			if isElement(sound) then
				stopSound(sound)
			end
		end
		
		Sounds.created[stoppedRes] = nil
	end
)

-- Exports
playSound = Sounds.play
playSound3D = Sounds.play3D