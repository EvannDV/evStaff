ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Report = {}

Warn = {}


RegisterNetEvent("ev:checkStaff")

AddEventHandler("ev:checkStaff", function()
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @i", {['i'] = xPlayer.identifier }, function(data)
		local finit = data[1].group
		print(finit)
		for k, v in pairs(evCheckStaff) do
        if finit == v.name then
            --print("Autorisé")
			TriggerClientEvent('ev:OpenStaff', _src, finit)
        else
            --print("No access")
        end
		end
    end)
end)


ESX.RegisterServerCallback('ev:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	cb(group)
end)


RegisterNetEvent('ev:report')
AddEventHandler('ev:report', function(nameduCouz, inside1)
    local source = source
    table.insert(Report, {
        name = nameduCouz,
        id = source,
        inside = inside1
    })
    TriggerClientEvent("ev:sendNotifForReport", -1, 1)

end)



ESX.RegisterServerCallback("ev:GetRep", function(source, cb)
    cb(Report)
end)



RegisterServerEvent("ev:closeReport")
AddEventHandler("ev:closeReport", function()
    table.remove(Report, name, id, inside)
end)



ESX.RegisterServerCallback('ev:retrievePlayers', function(playerId, cb)
    local players = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        table.insert(players, {
            id = "0",
            group = xPlayer.getGroup(),
            source = xPlayer.source,
            jobs = xPlayer.getJob().name,
            name = xPlayer.getName()
        })
    end

    cb(players)
end)


ESX.RegisterServerCallback('ev:retrieveStaffPlayers', function(playerId, cb)
    local playersadmin = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() ~= "user" then
        table.insert(playersadmin, {
            id = "0",
            group = xPlayer.getGroup(),
            source = xPlayer.source,
            jobs = xPlayer.getJob().name,
            name = xPlayer.getName()
        })
    end
end

    cb(playersadmin)
end)




--- Commande /tpm 


ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)



RegisterNetEvent('ev:info')
AddEventHandler('ev:info', function(targetInfo)
    evInfo = {}
    local source = source
    local xTarget = ESX.GetPlayerFromId(targetInfo)
    if xTarget ~= nil then

        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @i", {['i'] = xTarget.identifier }, function(data)
		    local nameInfo = data[1].firstname
            local name2info = data[1].lastname
            local jobInfo = data[1].job
            local moneyInfo = data[1].money
            local moneyInfo2 = data[1].bank
            local warnServ = data[1].warn
            local ReasonWarn = data[1].reasonw
            table.insert(evInfo, {
                name = nameInfo,
                name2 = name2info,
                job = jobInfo,
                moneyCash = moneyInfo,
                moneyBank = moneyInfo2,
                warnNumber = warnServ,
                reasonw = ReasonWarn,
            })
        end)

    else
        table.insert(evInfo, {
            name = "⛔ Joueur Hors Ligne ou inexistant ⛔",
            name2 = "",
            job = "❌",
            moneyCash = "❌",
            moneyBank = "❌",
            warnNumber = "❌",
            reasonw = "❌",
        })
    end


end)


ESX.RegisterServerCallback("ev:GetInfo", function(source, cb)
    cb(evInfo)
end)


RegisterNetEvent('ev:giveCash', function(cash)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(cash)
    TriggerClientEvent('esx:showNotification', source, "Vous venez de recevoir : ~b~"..cash.."~s~ $")

end)

RegisterNetEvent('ev:giveBanque', function(banque)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addBank(banque)
    TriggerClientEvent('esx:showNotification', source, "Vous venez de recevoir : ~b~"..banque.."~s~ $ sur votre compte en banque")

end)


RegisterNetEvent('ev:giveSale', function(sale)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney('black_money', sale)
    TriggerClientEvent('esx:showNotification', source, "Vous venez de recevoir : ~b~"..sale.."~s~ $ d'argent sale")

end)


RegisterNetEvent('ev:setWarn')
AddEventHandler('ev:setWarn', function(id, reason)
    local source = source 
    local xTarget = ESX.GetPlayerFromId(id)

    if xTarget ~= nil then

        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @i", {['i'] = xTarget.identifier }, function(data)
            local warnActu = data[1].warn
            local reasonActu = data[1].reasonw
            local finwarn = warnActu + 1
            local finreason = reasonActu.." || "..reason
            print(finwarn)
            print(finreason)
            MySQL.Async.execute('UPDATE `users` SET `warn`=@w, `reasonw`=@rw  WHERE identifier=@idt', {['@idt'] = xTarget.identifier, ['@w'] = finwarn, ['@rw'] = finreason}, function(rowsChange)
            print("liaison bdd ok")
            TriggerClientEvent('esx:showNotification', source, "Warn envoyé avec ~g~succès !")
            TriggerClientEvent('esx:showNotification', id, "Vous avez été warn par "..GetPlayerName(source).." : "..reason)
            end)
        end)
    else
        TriggerClientEvent('esx:showNotification', source, "Player invalid")
    end


end)

RegisterNetEvent('ev:remooveWarn')
AddEventHandler('ev:remooveWarn', function(id, number)
    local source = source
    local xTarget = ESX.GetPlayerFromId(id)
    if xTarget ~= nil then
        if number ~= "all" and number ~= "ALL" then

            MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @i", {['i'] = xTarget.identifier }, function(data)
                local warnActu = data[1].warn
                local reasonActu = data[1].reasonw
                local finwarn = warnActu - number
                local finreason = reasonActu.." <-{suppr}"
                MySQL.Async.execute('UPDATE `users` SET `warn`=@w, `reasonw`=@rw  WHERE identifier=@idt', {['@idt'] = xTarget.identifier, ['@w'] = finwarn, ['@rw'] = finreason}, function(rowsChange)
                    TriggerClientEvent('esx:showNotification', source, number.." warn enlevé pour l'id "..id)
                end)
            end)
        else
            MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @i", {['i'] = xTarget.identifier }, function(data)
                MySQL.Async.execute('UPDATE `users` SET `warn`=@w, `reasonw`=@rw  WHERE identifier=@idt', {['@idt'] = xTarget.identifier, ['@w'] = 0, ['@rw'] = "->"}, function(rowsChange)
                    TriggerClientEvent('esx:showNotification', source,"Tous les warns ont été enlevé pour l'id "..id)
                end)
            end)
        end
    else
        TriggerClientEvent('esx:showNotification', source, "Player invalid")
    end
    
end)




--- Kick 

RegisterServerEvent('ev:kickjoueur')
AddEventHandler('ev:kickjoueur', function(player, raison)
    local steam
    local playerId = source
    local PcName = GetPlayerName(playerId)
    local joueur = GetPlayerName(player)
    for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, 'steam:') then
            steam = string.sub(v, 7)
            break
        end
    end

    DropPlayer(player, raison)
end)

RegisterServerEvent('ev:kickjoueur2')
AddEventHandler('ev:kickjoueur2', function(player, raison)
    DropPlayer(player, raison)
end)




--- Give Veh with Keys




RegisterServerEvent('evStaff:Give')
AddEventHandler('evStaff:Give', function (vehToGive, closestPlayer)
    evReStock = {}
    local source = source
    local voit = vehToGive
    local pl2 = math.random(1,500000)
    local nameev = GetPlayerName(source)
	local ledonneur = ESX.GetPlayerFromId(source)
    local targetEV = ESX.GetPlayerFromId(closestPlayer)
    local receveur = closestPlayer
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles", {}, function(result)
        for k, v in pairs(result) do
		    evReStock = {
                plate = v.plate,
                owner = v.owner,
            }
            if pl2 == v.plate then
                print("Usefull Plate")
            else
                print("plate good")

            end
        end
			


		
    end)

        
        
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)',
    {
        ['@owner']   = targetEV.identifier,
        ['@plate']   = pl2,
        ['@vehicle'] = json.encode(vehToGive),
        ['@type'] = "car"
    }, function (rowsChanged)
        TriggerClientEvent('esx:showNotification', ledonneur.source, "Tu a bien donné le véhicule : "..vehToGive)
        TriggerClientEvent('esx:showNotification', receveur, "Tu a bien reçu le véhicule : "..vehToGive)
    end)
        TriggerClientEvent('evStaff:Create2', source, vehToGive, pl2)


end)

RegisterNetEvent('ev:fix')
AddEventHandler('ev:fix', function(Plaq, vehicleProps)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local play = xPlayer.identifier
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle`=@v  WHERE plate=@o', {['@v'] = json.encode(vehicleProps), ['@o'] = Plaq }, function(rowsChange)
        print("[^1Transfert^0] Tranfert réussi")
    end)

end)




RegisterServerEvent('ev:messageStaff')
AddEventHandler('ev:messageStaff', function(id, mess)
    local source = source

	TriggerClientEvent('esx:showNotification', source, "Votre message a bien été envoyé")
    TriggerClientEvent('esx:showAdvancedNotification', id, 'Staff', '~y~message', mess, 'CHAR_GANGAPP', 1)

end)

evSteamSiu = {}

RegisterNetEvent('ev:GetSteam')
AddEventHandler('ev:GetSteam', function(idPlyEv)
    local source = source
    local xTarget = ESX.GetPlayerFromId(idPlyEv)
    local SteamGotIt = xTarget.identifier
    local NameGotIt = xTarget.name
    table.insert(evSteamSiu, {
        steam = SteamGotIt,
        name = NameGotIt,
    })
end)


ESX.RegisterServerCallback("ev:GetSteam", function(source, cb)
    cb(evSteamSiu)
end)





------------- Recup Staff




ESX.RegisterServerCallback('ev:recupStaff', function(source, cb)
    local StaffOn = {}
    MySQL.Async.fetchAll('SELECT * FROM users', {}, function(result)
        for i = 1, #result, 1 do
            if result[i].group == "admin" or result[i].group == "superadmin" or result[i].group == "owner" or result[i].group == "mod" then
            table.insert(StaffOn, {
                name = result[i].firstname,
                name2 = result[i].lastname,
                groupe = result[i].group,
                permlvl = result[i].permission_level,
                identifier = result[i].identifier,
            })
            else
                --print("no Good Grade")
            end
        end
        cb(StaffOn)
    end)
    
end)


-----------------------------------------------
RegisterNetEvent('evModifGroup')
AddEventHandler('ev:ModifGroup', function(identiSt, newGr)
    local source = source

    MySQL.Async.execute('UPDATE `users` SET `group`=@g WHERE identifier=@idt', {['@idt'] = identiSt, ['@g'] = newGr}, function(rowsChange)
        TriggerClientEvent('esx:showNotification', source, "Group set as ~p~"..newGr)
    end)

end)

RegisterNetEvent('evModifPerm')
AddEventHandler('ev:ModifPerm', function(identiSt, newPermLvl)
    local source = source

    MySQL.Async.execute('UPDATE `users` SET `permission_level`=@p WHERE identifier=@idt', {['@idt'] = identiSt, ['@p'] = newPermLvl}, function(rowsChange)
        TriggerClientEvent('esx:showNotification', source, "Permission set à ~p"..newPermLvl)
    end)

end)


-------------------------------------------------------


RegisterServerEvent("announceEV")
AddEventHandler("announceEV", function(param)
    print("[Announcement]"..param)
    TriggerClientEvent("chatMessage", -1, "[Announcement]", {0,0,0}, param)
end)



---------------- Get Player Data 



ESX.RegisterServerCallback('ev:getOtherPlayerData', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)
  
    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout(),
            money = xPlayer.getMoney()
        }
  
        cb(data)
    end
end)




------------- Key List 

evKeyList = {}

ESX.RegisterServerCallback('evStaff:KeyList', function(source, cb)
    cb(evKeyList)
end)


RegisterNetEvent('evStaff:GiveKey')
AddEventHandler('evStaff:GiveKey', function(id)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(id)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @o", {['o'] = xPlayer.identifier }, function(data)
        for k, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(evKeyList, {vehicle = vehicle, plate = v.plate})

        end

    end)
end)



RegisterNetEvent('ev:ChangeGr')
AddEventHandler('ev:ChangeGr', function(id , keyb)
    local source = source
    print("ok")
    ExecuteCommand('setgroup '..id.." "..keyb)
    TriggerClientEvent('esx:showNotification', source, "Changement réalisé avec succès !")
end)