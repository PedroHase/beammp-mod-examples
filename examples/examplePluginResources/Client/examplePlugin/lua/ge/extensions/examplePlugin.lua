--examplePlugin (CLIENT)

local M = {} --metatable

--custom function called by command !jump (see server-side examplePlugin)
local function onJump(data)
	local height
	if data ~= "null" then
		data = jsonDecode(data)
		height = data[1] --get height (in meters) from the data sent by !jump command
	end
	if not height then --if no height argument is provided then
		height = 1 --set height to 1
	end
	print("onJump Called: " .. height .. " meters") --debug print so we can check in-game console
	local veh = be:getPlayerVehicle(0) --get the player's current vehicle as an object
	local vehPos = veh:getPosition() --get that vehicle's position
	vehPos.z = vehPos.z + height --offset that position in the z-axis by the height provided
	veh:setPosition(vehPos) --take the vehicle object and apply the new position
	TriggerServerEvent("onJump", height) --trigger "onJump" server-side and send the height as an argument
end

--custom function called by command !speed (see server-side examplePlugin)
local function onSpeed(data)
	local unit
	if data ~= "null" then
		data = jsonDecode(data)
		unit = data[1] --get unit from the data sent by !speed command
	end
	if not unit then --if no unit argument is provided then
		unit = "km/h" --set unit to "km/h"
	end
	print("onSpeed called: Unit: " .. unit) --debug print so we can check in-game console
	for i = 0, be:getObjectCount() - 1 do --iterate loop through all the objects
		local veh = be:getObject(i) --get an object
		local gameVehicleID = veh:getID() --get that object's ID
		local veh = be:getObjectByID(gameVehicleID) --get vehicle as an object by ID
		if MPVehicleGE.isOwn(gameVehicleID) then --if that vehicle is owned by the player then
			if unit == "km/h" or unit == "kmh" or unit == "KMH" then --if the unit is some variation of "km/h" then
				unit = "km/h" --standarize the unit
				local vehSpeed = veh:getVelocity():len()*3.6156885440944 --calculate the speed
				TriggerServerEvent("onSpeed", string.format("%.2f", vehSpeed) .. " " .. unit) --trigger "onSpeed" server-side and send the speed and unit as a string as an argument
			elseif unit == "mph" or unit == "MPH" then --otherwise if the unit is a variation of "mph" then
				unit = "mph" --standarize the unit
				local vehSpeed = veh:getVelocity():len()*2.2369362920544 --calculate the speed
				TriggerServerEvent("onSpeed", string.format("%.2f", vehSpeed) .. " " .. unit) --trigger "onSpeed" server-side and send the speed and unit as a string as an argument
			end
		end
	end
end

local function onExtensionLoaded()
	print("--------------------Loading examplePlugin") --debug print so we can check in-game console
	AddEventHandler("jump", onJump) --name of event to call (string), and the function that calling this event will process
	AddEventHandler("speed", onSpeed) --so, in this example, when the server triggers the client event "speed", the client does the onSpeed function
end

local function onExtensionUnloaded()
	print("--------------------Unloading examplePlugin") --debug print so we can check in-game console
end

M.onExtensionLoaded = onExtensionLoaded --these are exposed globally via the metatable so that they can be called by the game itself
M.onExtensionUnloaded = onExtensionUnloaded

return M --return the metatable
