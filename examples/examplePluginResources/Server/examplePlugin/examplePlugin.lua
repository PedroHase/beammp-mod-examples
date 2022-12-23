--examplePlugin (SERVER)

local commandPrefix = "!" --prefix used to identify commands entered through chat

players = {} --table to hold information about players

function onInit() --runs when plugin is loaded

	--Provided by BeamMP
	MP.RegisterEvent("onPlayerAuth", "onPlayerAuth")
	MP.RegisterEvent("onPlayerConnecting", "onPlayerConnecting")
	MP.RegisterEvent("onPlayerJoining", "onPlayerJoining")
	MP.RegisterEvent("onPlayerJoin", "onPlayerJoin")
	MP.RegisterEvent("onPlayerDisconnect", "onPlayerDisconnect")
	MP.RegisterEvent("onChatMessage", "onChatMessage")
	MP.RegisterEvent("onVehicleSpawn", "onVehicleSpawn")
	MP.RegisterEvent("onVehicleEdited", "onVehicleEdited")
	MP.RegisterEvent("onVehicleReset", "onVehicleReset")
	MP.RegisterEvent("onVehicleDeleted", "onVehicleDeleted")
	
	--Custom
	MP.RegisterEvent("onJump", "onJump")
	MP.RegisterEvent("onSpeed", "onSpeed")
	
	print("--------------------examplePlugin loaded")

end

--A player has authenticated and is requesting to join
--The player's name (string), forum role (string), guest account (bool), identifiers (table -> ip, beammp)
function onPlayerAuth(player_name, role, isGuest, identifiers)
	--print("onPlayerAuth: player_name: " .. player_name .. " | role: " .. role .. " | isGuest: " .. tostring(isGuest) .. " | ip: " .. ip .. " | beammp: " .. beammp)
	players[player_name] = {
		["name"] = player_name,
		["role"] = role,
		["isGuest"] = isGuest,
		["identifiers"] = identifiers
	}
end

--A player is loading in (Before loading the map)
--The player's ID (number)
function onPlayerConnecting(player_id)
	player_name = MP.GetPlayerName(player_id)
	players[player_id] = players[player_name]
	players[player_id].id = player_id
	players[player_name] = nil
end

--A player is loading the map and will be joined soon
--The player's ID (number)
function onPlayerJoining(player_id)
	
end

--A player has joined and loaded in
--The player's ID (number)
function onPlayerJoin(player_id)
	MP.SendChatMessage(-1, players[player_id].name .. " has joined the server!")
	players[player_id].vehicles = {}
end

--A player has disconnected
--The player's ID (number)
function onPlayerDisconnect(player_id)
	MP.SendChatMessage(-1, players[player_id].name .. " has left the server!")
	players[player_id] = nil
end

--A chat message was sent
--The sender's ID, the sender's name, and the chat message
function onChatMessage(player_id, player_name, message)
	if message:sub(1,1) == commandPrefix then --if the character at index 1 of the string is the command prefix then
		command = string.sub(message,2) --the command is everything in the chat message from string index 2 to the end of the string
		onCommand(player_id, command) --call the onCommand() function passing in the player's ID and the command string
		return 1 --prevent the command from showing up in the chat
	else --otherwise do nothing
	end
end

--This is called when someone spawns a vehicle
--The player's ID (number), the vehicle ID (number), and the vehicle data (json)
function onVehicleSpawn(player_id, vehicle_id, data)
	local s = data:find('%{')
	data = data:sub(s)
	data = Util.JsonDecode(data)
	players[player_id].vehicles[vehicle_id] = data.jbm
end

--This is called when someone edits a vehicle, or replaces their existing one
--The player's ID (number), the vehicle ID (number), and the vehicle data (json)
function onVehicleEdited(player_id, vehicle_id, data)
	local s = data:find('%{')
	data = data:sub(s)
	data = Util.JsonDecode(data)
	players[player_id].vehicles[vehicle_id] = data.jbm
end

--This is called when someone resets a vehicle
--The player's ID (number), the vehicle ID (number), and the vehicle data (json)
function onVehicleReset(player_id, vehicle_id, data)

end

--This is called when someone deletes a vehicle they own
--The player's ID (number) and the vehicle ID (number)
function onVehicleDeleted(player_id, vehicle_id)
	players[player_id].vehicles[vehicle_id] = nil
end

------------------------------BEGIN CUSTOM FUNCTIONS------------------------------

--This will be called when the client-side examplePlugin triggers the server event "onJump"
--The player's ID, and the data
function onJump(player_id, data)
	MP.SendChatMessage(-1, MP.GetPlayerName(player_id) .. " jumped " .. data .. " meters")
end

--This will be called when the client-side examplePlugin triggers the server event "onSpeed"
--The player's ID, and the data
function onSpeed(player_id, data)
	MP.SendChatMessage(-1, MP.GetPlayerName(player_id) .. "'s speed is: " .. data)
end

--This is called when a command is entered in chat
--The player's ID, and the data containing the command and the arguments
function onCommand(player_id, data)
	local data = split(data)
	local command = data[1] --get the command from the data
	local args = {} --initialize an arguments table
	if data[2] then --if there is at least one argument
		local argIndex = 1
		for dataIndex = 2, #data do
			args[argIndex] = data[dataIndex]
			argIndex = argIndex + 1
		end
	end
	MP.TriggerClientEventJson(player_id, command, args) --trigger the client event for the player that entered the command, sending arguments
end

--function for splitting strings by a separator into a table
function split(str, sep)
	local sep = sep or " "
	local t = {}
	for str in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end
