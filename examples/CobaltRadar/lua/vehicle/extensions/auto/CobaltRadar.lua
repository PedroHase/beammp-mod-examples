--Copyright (C) 2020, Preston Elam (CobaltTetra) ALL RIGHTS RESERVED
--THIS SCRIPT IS PROTECTED UNDER AN GPLv3 LICENSE

--    PRE: Precondition
--   POST: Postcondition
--RETURNS: What the method returns


local M = {}
local radarVehicles = {}
local radarScale = 7.5

----------------------------------------------------------INIT-----------------------------------------------------------


----------------------------------------------------------EVENTS-----------------------------------------------------------

--runs when the script is called.
local function onInit()
	
end

--is called when the vehicle is reset
local function onReset()
	
end

-- PRE: dt is passed in, the delta  time since the last frame in seconds.
--POST: All of the updaters are ran aswell as other things that need to be ran each frame.
local function updateGFX(dt)
	if playerInfo.firstPlayerSeated then --My Car

		local radarStream = {}

		local me = obj:getPosition()
		local w = obj:getInitialWidth() * radarScale
		local l = obj:getInitialLength() * radarScale
		local myRot = quat(obj:getRotation()):toEulerYXZ().x - (math.pi/2)*5

		radarStream.opacity = 0

		for id,data in pairs(radarVehicles) do
			if data.age < 1 then
				data.dist = math.sqrt(math.abs(data.x - me.x)^2+math.abs(data.y-me.y)^2)
				if data.dist > 20 then
					data.opacity = 1 - ((data.dist - 20) * 1/15)
				else
					data.opacity = 1
				end
				if data.opacity > radarStream.opacity then
					radarStream.opacity = data.opacity
				end


				data.x = (data.x - me.x) * radarScale
				data.y = (data.y - me.y) * radarScale
			else
				radarVehicles[id] = nil
			end
			data.age = data.age + 1
		end

		local rightCorner
		local leftCorner
		local offset
		local unicycle = false
		if v.config.model == "unicycle" then
			unicycle = true
			offset = {x = 0, y = 0}
		else
			ref = v.data.nodes[v.data.refNodes[0].ref].pos
			--rightCorner = v.data.nodes[v.data.refNodes[0].rightCorner].pos
			--leftCorner = v.data.nodes[v.data.refNodes[0].leftCorner].pos
			--backNode = v.data.nodes[v.data.refNodes[0].back].pos
			--offset = {x = (rightCorner.x + leftCorner.x)/2 * radarScale, y = (rightCorner.y + backNode.y)/2 * radarScale }
			offset = {x = ref.x * radarScale , y = ref.y * radarScale}
		end

		--print("--------" .. "THING" .. "--------")
		--print("L:" .. offset.x)
		--print("B:" .. offset.y)
		--print("W:" .. w/radarScale)
		--print("L:" .. l/radarScale)

		--print("X:" .. offset.x/radarScale .. " Y:" .. offset.y/radarScale)

		radarStream.w = w
		radarStream.l = l
		radarStream.myRot = myRot + math.pi
		radarStream.offset = offset
		--radarStream.left = v.data.nodes[v.data.refNodes[0].left].pos.x * radarScale
		--radarStream.back = v.data.nodes[v.data.refNodes[0].back].pos.y * radarScale
		radarStream.left = offset.x
		radarStream.back = offset.y

		radarStream.cars = radarVehicles
		
		gui.send("CobaltRadar",radarStream)
	
	else --Other cars
		local w = obj:getInitialWidth()
		local l = obj:getInitialLength()

		local me = obj:getPosition()
		local rot = quat(obj:getRotation()):toEulerYXZ().x
		--local left = v.data.nodes[v.data.refNodes[0].left].pos.x * radarScale
		--local back = v.data.nodes[v.data.refNodes[0].back].pos.y * radarScale

		local rightCorner
		local leftCorner
		local offset
		local unicycle = false
		if v.config.model == "unicycle" then
			unicycle = true
			offset = {x = 0, y = 0}
		else
			ref = v.data.nodes[v.data.refNodes[0].ref].pos
			--rightCorner = v.data.nodes[v.data.refNodes[0].rightCorner].pos
			--leftCorner = v.data.nodes[v.data.refNodes[0].leftCorner].pos
			--backNode = v.data.nodes[v.data.refNodes[0].back].pos
			--offset = {x = (rightCorner.x + leftCorner.x)/2 * radarScale, y = (rightCorner.y + backNode.y)/2 * radarScale }
			offset = {x = ref.x * radarScale , y = ref.y * radarScale}
		end

		local left = offset.x
		local back = offset.y

		--if v and v.config and v.config.model then
		--end
		local carColor
		local vehID = obj:getID()
		if v.config.colors and v.config.colors[1] then
			carColor = v.config.colors[1]
		else
			carColor = {1,1,1}
		end

		obj:queueGameEngineLua('be:getPlayerVehicle(0):queueLuaCommand("CobaltRadar.setVehColor(' .. vehID .. ', " .. tostring(scenetree.findObjectById(' .. vehID .. ').color) .. ")")')
		obj:queueGameEngineLua('be:getPlayerVehicle(0):queueLuaCommand("CobaltRadar.setVehLocation(' .. vehID .. ',' .. w .. ',' .. l .. ','.. rot ..',{' .. me.x .. ',' .. me.y .. '},'.. back ..','.. left ..',{' .. carColor[1] .. "," .. carColor[2] .. "," .. carColor[3] .. "}," .. tostring(unicycle) .. ')")')
	end

	--for k, w in pairs(wheels.wheels) do
		--if w.contactMaterialID1 == 10 then
			--w.contactMaterialID1 = 11
			--obj:addParticleByNodesRelative(w.lastTreadContactNode,0,1,50, 0, 1)
			
			--obj:addParticleByNodesRelative(w.lastTreadContactNode,w.lastTreadContactNode,1,50,0.2, 10)
		--end
	--end
end

----------------------------------------------------------MUTATORS---------------------------------------------------------
local function setVehLocation(id,w,l,rot,pos,back,left,rgb,unicycle)
	if radarVehicles[id] == nil then
		radarVehicles[id] = {}
		radarVehicles[id].color = {1,1,1}
	end

	--radarVehicles[id].color = rgb
	radarVehicles[id].w = w * radarScale
	radarVehicles[id].l = l * radarScale
	radarVehicles[id].rot = rot + math.pi/2
	radarVehicles[id].x = pos[1]
	radarVehicles[id].y = pos[2]
	radarVehicles[id].back = back
	radarVehicles[id].left = left
	radarVehicles[id].unicycle = unicycle

	radarVehicles[id].age = 0 --age in frames
	--print(rot)


	--radarVehicles[id].p1 = p1
	--radarVehicles[id].p2 = p2
	--
	--local p3 = {}
	--p3[1] = (p1[1] - pos[1]) * -1 + pos[1]
	--p3[2] = (p1[2] - pos[2]) * -1 + pos[2]
	--
	--local p4 = {}
	--p4[1] = (p2[1] - pos[1]) * -1 + pos[1]
	--p4[2] = (p2[2] - pos[2]) * -1 + pos[2]
	--
	--radarVehicles[id].p3 = p3
	--radarVehicles[id].p4 = p4
	
	--radarVehicles[id].p1 = p1

	--radarVehicles[id].p3 = p3


	

	--radarVehicles[id].p2 = p2
	--radarVehicles[id].p4 = p4

	--radarVehicles[id].frames = 0


	--print(p1[1] .. " " .. p1[2] .. " | " .. p2[1] .. " " .. p2[2])
end

local function setVehColor(id,r,g,b,a)
	if radarVehicles[id] ~= nil then
		radarVehicles[id].color = {r,g,b}
	
	end
end


---------------------------------------------------------ACCESSORS---------------------------------------------------------



---------------------------------------------------------FUNCTIONS---------------------------------------------------------



------------------------------------------------------PUBLICINTERFACE------------------------------------------------------


----EVENTS-----
M.onInit = onInit
M.onReset = onReset
M.updateGFX = updateGFX

----MUTATORS-----
M.setVehLocation = setVehLocation
M.setVehColor = setVehColor
----ACCESSORS----

----FUNCTIONS----


return M