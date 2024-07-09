
------------------------------------------------------------------------------------------

	local peds = {}

	function createWorldPed(config)

		local x,y,z,r = unpack(config.position.coords)

		local ped = createPed(config.model, x,y,z,r)
		ped.dimension = config.position.dim
		ped.interior = config.position.int

		ped.frozen = true

		peds[ped] = {}

		ped:setData('attach', config.attachToLocalPlayer)
		ped:setData('3dText', config.text)

		peds[ped].bones = {}
		for bone, data in pairs( config.bones or {} ) do

			local object = addPedBoneObject(ped, bone, data)
			peds[ped].bones[bone] = object

		end

		peds[ped].resource = sourceResource.name

		initPedAnimations(ped, config)

		return ped

	end

	function destroyResourcePeds(resource)
		for ped, data in pairs(peds) do
			if data.resource == resource.name then
				if isElement(ped) then
					destroyPedBoneObjects(ped)
					destroyPedBoneAnimations(ped)
					destroyElement(ped)
				end
				peds[ped] = nil
			end
		end
	end

	addEventHandler('onClientResourceStop', root, destroyResourcePeds)
	addEventHandler('onResourceStop', root, destroyResourcePeds)


------------------------------------------------------------------------------------------

	function destroyPedBoneObjects(ped)
		local bones = peds[ped].bones
		for _, object in pairs(bones) do
			destroyElement(object)
		end
	end

	function addPedBoneObject(ped, bone, data)

		local object = createObject(data.model, 0, 0, 0)
		object.scale = data.scale or 1

		exports.bone_attach:attachElementToBone(object, ped, bone, unpack(data.offsets or {}))

		return object

	end

------------------------------------------------------------------------------------------

	function destroyPedBoneAnimations(ped)
		local pedData = peds[ped]
		if not pedData then return end

		if isTimer(pedData.anim_timer) then
			killTimer(pedData.anim_timer)
		end
	end

	function initPedAnimations(ped, config)

		if not config.animations then return end

		local pedData = peds[ped]
		if not pedData then return end

		pedData.anim_steps = config.animations.steps
		pedData.anim_step = 1
		pedData.anims = config.animations.cycles

		pedData.anim_timer = setTimer(function(ped)

			local pedData = peds[ped]
			if not pedData then return end

			local animation = pedData.anims[pedData.anim_step]
			if animation then
				setPedAnimation(ped, unpack(animation))
			end

			pedData.anim_step = pedData.anim_step + 1
			if pedData.anim_step > pedData.anim_steps then
				pedData.anim_step = 1
			end

		end, config.animations.time, 0, ped)

	end