local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local shouldshow = true
--local isTalking = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
	TriggerEvent('es:setMoneyDisplay', 0.0)
	ESX.UI.HUD.SetDisplay(0.0)
	
	--NetworkSetTalkerProximity(10.0)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	local data = xPlayer
	local accounts = data.accounts
	for k,v in pairs(accounts) do
		local account = v
		if account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
		end
	end

	local job = data.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
	--SendNUIMessage({action = "setValue", key = "job", value = job.grade_label})
	SendNUIMessage({action = "setValue", key = "money", value = "$"..data.money})
	SendNUIMessage({action = "setValue", key = "playerid", value = "ID "..GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))   })
	--SendNUIMessage({action = "setValue", key = "plz", value = "PLZ "..plz_text_2   })
end)

---PLZ------------------------------------------------------------------------
--RegisterNetEvent("nearest_postal_hud")
--AddEventHandler("nearest_postal_hud", function(plz_text_2)
	--print ("PLZ"..plz_text_2)
--	SendNUIMessage({action = "setValue", key = "playerid", value = "ID "..GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))).." | PLZ "..plz_text_2})
--	Citizen.Wait(10)
--end)
---PLZ------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		ESX.UI.HUD.SetDisplay(0.0)
		if isTalking == false then
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({action = "setTalking", value = true})
			end
		else
			if NetworkIsPlayerTalking(PlayerId()) == false then
				isTalking = false
				SendNUIMessage({action = "setTalking", value = false})
			end
		end
	end
end)

local prox = 26.0
local allowProximityChange = true

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 48) and allowProximityChange then
			local vprox
			if prox <= 2.0 then
				prox = 10.0
				vprox = "normal"
			elseif prox == 10.0 then
				prox = 26.0
				vprox = "shout"
			elseif prox >= 26.0 then
				prox = 2.0
				vprox = "whisper"
			end
			--NetworkSetTalkerProximity(prox)
			SendNUIMessage({action = "setProximity", value = vprox})
		end
		if IsControlPressed(1, 20) then
			local posPlayer = GetEntityCoords(GetPlayerPed(-1))
			--DrawMarker(1, posPlayer.x, posPlayer.y, posPlayer.z - 1, 0, 0, 0, 0, 0, 0, prox * 2, prox * 2, 0.8001, 0, 75, 255, 165, 0,0, 0,0)
		end
	end
end)

RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "bank" then
		SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
  --SendNUIMessage({action = "setValue", key = "job", value = job.grade_label})
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(e)
	SendNUIMessage({action = "setValue", key = "money", value = "$"..e})
end)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)