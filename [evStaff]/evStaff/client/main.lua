ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

ev = {} or {};

ev.SelfPlayer = {
    isDelgunEnabled = false,
    isPistolKick = false,
};

StaffOnline = {}
StockSteam = {}
gamerTags = {}
ShowName = false
InfoPly = {}
reportCLi = {}
CliWarn = {}
ev.Helper = {} or {}
ev.SelectedPlayer = {};
ev.Players = {} or {}
ev.PlayersStaff = {} or {}
ev.SelectedPlayerSt = {};

RegisterNetEvent('ev:OpenStaff')
AddEventHandler('ev:OpenStaff', function(GroupUtil)
    ESX.TriggerServerCallback('ev:GetRep', function(result)
        reportCLi = result
    end)
    OpenStaffMain(GroupUtil)
end)

RegisterCommand('Staff', function()
    TriggerServerEvent('ev:checkStaff')
end)

RegisterKeyMapping('Staff', 'Ouvrir le Menu Staff', 'keyboard', 'F10')



function ev.Helper:OnGetPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('ev:retrievePlayers', function(players)
        clientPlayers = players
    end)

    while not clientPlayers do
        Citizen.Wait(10)
    end
    return clientPlayers
end

function ev.Helper:OnGetStaffPlayers()
    local evStaff = false;
    ESX.TriggerServerCallback('ev:retrieveStaffPlayers', function(players)
        evStaff = players
    end)
    while not evStaff do
        Citizen.Wait(10)
    end
    return evStaff
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)

            ev.Players = ev.Helper:OnGetPlayers()
            ev.PlayersStaff = ev.Helper:OnGetStaffPlayers()
    end
end)

local function getEntity(player)
    local _, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

local function aimCheck(player)
    return IsPedShooting(player)
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if ev.SelfPlayer.isDelgunEnabled == true then
            if IsPlayerFreeAiming(PlayerId()) then
                local entity = getEntity(PlayerId())
                if GetEntityType(entity) == 2 or 3 then
                    if aimCheck(PlayerPedId()) then
                        SetEntityAsMissionEntity(entity, true, true)
                        DeleteEntity(entity)
                    end
                end
            end
        end

        --[[if ev.SelfPlayer.isPistolKick == true then
            if IsPlayerFreeAiming(PlayerId()) then
                local entity = getEntity(PlayerId())
                local raisonEvPist = "OMG LE PISTOL KICK DANS TA GM" 
                    if aimCheck(PlayerPedId()) then
                        SetEntityAsMissionEntity(entity, true, true)
                        TriggerServerEvent('ev:kickjoueur2', entity, raisonEvPist)
                    end
            end
        end]]--
    end
end)


function OpenStaffMain(GroupUtil)

    local StaffEV = RageUI.CreateMenu(Config.UrServ,"Administration")
    local subReport = RageUI.CreateSubMenu(StaffEV, "Report", "Administration")
    local subReport2 = RageUI.CreateSubMenu(subReport, "Report", "Administration")
    local subOptions = RageUI.CreateSubMenu(StaffEV, "Options", "Administration")
    local subInfo = RageUI.CreateSubMenu(subOptions, "Informations", "Administration")
    local subActivePly = RageUI.CreateSubMenu(StaffEV, "Joueurs connectés", "Administration")
    local subPerso = RageUI.CreateSubMenu(StaffEV, "Staff", "Administration")
    local subSanctions = RageUI.CreateSubMenu(StaffEV, "Sacntions", "Administration")
    local subVehicules = RageUI.CreateSubMenu(StaffEV, "Véhicules", "Administration")
    local subAfterCo = RageUI.CreateSubMenu(subActivePly, "Staff", Config.UrServ)
    local subStaff = RageUI.CreateSubMenu(StaffEV, "Staff", Config.UrServ)
    local subStaff2 =RageUI.CreateSubMenu(subStaff, "Staff", Config.UrServ)
    local subInv = RageUI.CreateSubMenu(subReport2, "Inventaire", Config.UrServ)
    local subInvSt = RageUI.CreateSubMenu(subStaff2, "Inventaire", Config.UrServ)
    local subInvActive = RageUI.CreateSubMenu(subAfterCo, "Inventaire", Config.UrServ)
    local subKeyStaff = RageUI.CreateSubMenu(subReport2, "Key Menu", Config.UrServ)
    
    
    

    RageUI.Visible(StaffEV, not RageUI.Visible(StaffEV))

    while StaffEV do
        
        Citizen.Wait(0)

        RageUI.IsVisible(StaffEV,true,true,true,function()
            nameUtil = GetPlayerName(PlayerId())

            RageUI.Checkbox("Activer le mode Staff", nil, etat,{},function(Hovered,Ative,Selected,Checked)
                StaffOn = Checked;
                if Selected then
                    etat = Checked
                    if etat==true then
                        onservice = true
                        StaffOn = true
                        Citizen.CreateThread(function()
                            while StaffOn do
                                Wait(1)
                                RageUI.Text({message = "~y~"..nameUtil.."~s~ | ~b~"..GroupUtil.."~s~ Vous avez : ~r~"..#reportCLi.."~s~ reports"})
                            end
                        end)
                        if evCore.IsEnabledStaffClothes == true then 
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerEvent('skinchanger:loadClothes', skin, {
                            ['bags_1'] = 0, ['bags_2'] = 0,
                            ['tshirt_1'] = 15, ['tshirt_2'] = 2,
                            ['torso_1'] = 178, ['torso_2'] = 5,
                            ['arms'] = 31,
                            ['pants_1'] = 77, ['pants_2'] = 5,
                            ['shoes_1'] = 55, ['shoes_2'] = 5,
                            ['mask_1'] = 0, ['mask_2'] = 0,
                            ['bproof_1'] = 0,
                            ['chain_1'] = 0,
                            ['helmet_1'] = 91, ['helmet_2'] = 5,
                        })
                        end)
                        else
                            print("nop")
                        end

                        ESX.ShowNotification("~g~Mode Staff Activé")
                        
                    else
                        if etat==false then
                            onservice = false
                            if evCore.IsEnabledStaffClothes == true then 
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                end)
                                else
                                    print("nop")
                                end
                            ESX.ShowNotification("~r~Mode Staff Désactivé")
                        end
                    end
                end
            end)

            if StaffOn then
                

                RageUI.Separator("     Votre nom : ~y~"..nameUtil.."~s~    ~s~")
                RageUI.Separator("    Id :    ~b~"..GetPlayerServerId(PlayerId()).."   ")
                RageUI.Separator("     Votre rank : ~o~"..GroupUtil.."~s~    ~s~")
        
            
                RageUI.ButtonWithStyle("~p~→ ~s~Reports ( ~r~"..#reportCLi.."~s~ )", nil, {RightLabel = "~p~→→"}, true, function(Hovered, Active, Selected)
                end, subReport)

                RageUI.ButtonWithStyle("~p~→ ~s~Joueurs connectés", nil, {RightLabel = "~p~→→"}, true, function(Hovered, Active, Selected)
                end, subActivePly)

                RageUI.ButtonWithStyle("~p~→ ~s~Gestion des Staffs", nil, {RightLabel = "~p~→→"}, true, function(Hovered, Active, Selected)
                end, subStaff)

                RageUI.ButtonWithStyle("~p~→ ~s~Personnel", nil, {RightLabel = "~p~→→"}, true, function(Hovered, Active, Selected)
                end, subPerso)

                RageUI.ButtonWithStyle("~p~→ ~s~Options", nil, {RightLabel = "~p~→→"}, true, function(Hovered, Active, Selected)
                end, subOptions)

                RageUI.ButtonWithStyle("~p~→ ~s~Sanctions", nil, {RightLabel = "~p~→→"}, true, function(Hovered, Active, Selected)
                end, subSanctions)

                RageUI.ButtonWithStyle("~p~→ ~s~Véhicules", nil, {RightLabel = "~p~→→"}, true, function(Hovered, Active, Selected)
                end, subVehicules)





            end
            
        end, function()
        end)

        RageUI.IsVisible(subReport,true,true,true,function()



        
            if #reportCLi >= 1 then
                RageUI.Separator("↓   Reports   ↓")

                for k,v in pairs(reportCLi) do
                    RageUI.ButtonWithStyle(k.." - Report de ~r~"..v.name, nil, {RightLabel = "Id : ~b~"..v.id.."~s~"},true , function(_,_,s)
                        if s then
                            nom = v.name
                            nbreport = k
                            id = v.id
                            raison = v.inside
                            TriggerServerEvent('evStaff:GiveKey', id)
                            Citizen.Wait(200)
                            ESX.TriggerServerCallback('evStaff:KeyList', function(result)
                                Keys.evList = result
                             --   print(json.encode(myGang, {indent = true})) 
                            end)
                        end
                    end, subReport2)
                end
            else
                RageUI.Separator("")
                RageUI.Separator("~r~Aucun ~o~Report~s~")
                RageUI.Separator("")
            end




            
        end, function()
        end)


        RageUI.IsVisible(subReport2,true,true,true,function()

            RageUI.Separator("")
            RageUI.Separator("~y~"..nom.." | id : ~b~"..id)
            RageUI.Separator("~o~Raison : ~s~"..raison)
            RageUI.Separator("")

            RageUI.ButtonWithStyle("~g~→~s~ Voir l'inventaire", nil, {RightLabel = "→→"},true , function(_,_,s)
                if s then
                    getPlayerInv(GetPlayerFromServerId(id))
                end
            end, subInv)

            RageUI.ButtonWithStyle("~g~→~s~ Voir les clés", nil, {RightLabel = "→→"},true , function(_,_,s)
            end, subKeyStaff)

            RageUI.ButtonWithStyle("~p~→~s~ Se télétporter sur le joueur", nil, {RightLabel = "→→"},true , function(_,_,s)
                if s then
                    ExecuteCommand("goto "..id)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Téléporter sur soi", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("bring "..id)
                end
            end)

            RageUI.Checkbox("~p~→~s~ Freeze / Defreeze", nil, Freeze,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    Freeze = Checked
                    if Checked then
                        ExecuteCommand("freeze "..id)
                        RageUI.Popup({message = "Joueur ~r~Freeze"})
                    else
                        ExecuteCommand("unfreeze "..id)
                        RageUI.Popup({message = "Joueur ~g~Unfreeze"})
                    end
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Spectate", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("spect "..id)
                    evTouch = true
                    while evTouch == true do
                        if IsControlPressed(1, 38) then
                            ExecuteCommand("spect "..GetPlayerServerId(PlayerId()))
                            evTouch = false
                        end
                    end
                end
            end)


            RageUI.ButtonWithStyle("~p~→~s~ Fermer le Report", nil, {RightLabel = "→→"},true , function(_,_,s)
                if s then
                    TriggerServerEvent('ev:closeReport')
                    evActu()
                    ESX.ShowNotification("Report ~r~Fermé")
                    RageUI.CloseAll()
                end
            end)



            
        end, function()
        end)


        RageUI.IsVisible(subOptions,true,true,true,function()


            RageUI.Checkbox("~p~→~s~ Noclip", nil, NoclipEv,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    NoclipEv = Checked
                    if Checked then
                        ExecuteCommand('noclip')
                    else
                        ExecuteCommand('noclip')
                        print("off")
                    end
                end
            end)


            RageUI.Checkbox("~p~→~s~ GodMod", nil, God,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    God = Checked
                    if Checked then
                        SetEntityInvincible(GetPlayerPed(), true)
                        SetPlayerInvincible(PlayerId(), true)
                        SetPedCanRagdoll(GetPlayerPed(), false)
                        ClearPedBloodDamage(GetPlayerPed())
                        ResetPedVisibleDamage(GetPlayerPed())
                        ClearPedLastWeaponDamage(GetPlayerPed())
                        SetEntityProofs(GetPlayerPed(), true, true, true, true, true, true, true, true)
                        SetEntityOnlyDamagedByPlayer(GetPlayerPed(), false)
                        SetEntityCanBeDamaged(GetPlayerPed(), false)
                        ESX.ShowNotification("Vous êtes en GodMod")
                    else
                        SetEntityInvincible(GetPlayerPed(), false)
                        SetPlayerInvincible(PlayerId(), false)
                        SetPedCanRagdoll(GetPlayerPed(), true)
                        ClearPedLastWeaponDamage(GetPlayerPed())
                        SetEntityProofs(GetPlayerPed(), false, false, false, false, false, false, false, false)
                        SetEntityOnlyDamagedByPlayer(GetPlayerPed(), true)
                        SetEntityCanBeDamaged(GetPlayerPed(), true)
                        ESX.ShowNotification("Vous n'êtes plus en GodMod")
                    end
                end
            end)


            RageUI.Checkbox("~p~→~s~ Invisible", nil, invisibilite,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    invisibilite = Checked
                    if Checked then
                        SetEntityVisible(GetPlayerPed(-1), false, false)
                        ESX.ShowNotification("Invisibilité activé")
                    else
                        SetEntityVisible(GetPlayerPed(-1), true, false)
                        ESX.ShowNotification("Invisibilité désactivé")
                    end
                end
            end)


            RageUI.Checkbox("~p~→~s~ Courir plus vite", nil, rapide,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    rapide = Checked
                  if Checked then
                    SetPedCanRagdoll(GetPlayerPed(), false)
                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                    
                  else
                    SetPedCanRagdoll(GetPlayerPed(), true)
                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                    
                  end
                end
            end)


         


            RageUI.Checkbox("~p~→~s~ Afficher les Noms", nil, affichername,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    affichername = Checked
                    if Checked then
                        ShowName = true
                    else
                        ShowName = false
                    end
                end
            end)

            RageUI.Checkbox("~p~→~s~ Delgun", nil, ev.SelfPlayer.isDelgunEnabled ,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    evDel = Checked
                    if Checked then
                        ESX.ShowNotification("Delgun ~g~activé")
                        ev.SelfPlayer.isDelgunEnabled = true
                    else
                        ESX.ShowNotification("Delgun ~r~désactivé")
                        ev.SelfPlayer.isDelgunEnabled = false
                    end
                end
            end)

            --[[RageUI.Checkbox("~p~→~s~ Pistol Kick", nil, ev.SelfPlayer.isPistolKick ,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    evPistolkick = Checked
                    if Checked then
                        ESX.ShowNotification("Pistol Kick ~g~activé")
                        ev.SelfPlayer.isPistolKick = true
                    else
                        ESX.ShowNotification("Pistol Kick ~r~désactivé")
                        ev.SelfPlayer.isPistolKick = false
                    end
                end
            end)]]--




            RageUI.ButtonWithStyle("~p~→~s~ Info Joueur", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local plyId = KeyboardInput("Id du joueur","",10)
                    TriggerServerEvent('ev:info', plyId)
                    ESX.ShowNotification("Chargement des infos ...")
                    Citizen.Wait(2500)
                    ESX.TriggerServerCallback('ev:GetInfo', function(result)
                        InfoPly = result
                    end)

                    
                end
            end, subInfo)



            RageUI.ButtonWithStyle("~p~→~s~ Se téléporter sur le Marker", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("tpm")
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Se téléporter sur Coordonnées", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local X = KeyboardInput("X","",20)
                    local Y = KeyboardInput("Y","",20)
                    local Z = KeyboardInput("Z","",20)
                    ExecuteCommand("tp "..X.." "..Y.." "..Z)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Faire une annonce", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local announceSt = KeyboardInput("Votre annonce : ", "", 80)
                    ExecuteCommand("announceEV "..announceSt)
                end
            end)



            
        end, function()
        end)

        RageUI.IsVisible(subInfo,true,true,true,function()

            
            

            for k, v in pairs(InfoPly) do
                RageUI.Separator("")
                RageUI.Separator("~y~"..v.name.." "..v.name2)
                RageUI.Separator("Job : "..v.job)
                RageUI.Separator("Money Cash : "..v.moneyCash.." $")
                RageUI.Separator("Money Bank : "..v.moneyBank.." $")
                RageUI.Separator("")
                RageUI.Separator("Warn : ~o~"..v.warnNumber)
                RageUI.Separator("Raison : "..v.reasonw)
            end



            
        end, function()
        end)

        RageUI.IsVisible(subActivePly,true,true,true,function()


        
                table.sort(ev.Players, function(a,b) return a.source < b.source end)

                    if (#ev.Players > 0) then

                        for i, v in pairs(ev.Players) do
                            local gamertage = {
                                ["user"] = "Joueurs",
                                ["help"] = "Helpeur",
                                ["mod"] = "Modo",
                                ["admin"] = "Admin",
                                ["superadmin"] = "SuperAdmin",
                                ["owner"] = "Fondateur",
                                ["_dev"] = "Developper",
                            }                 
                            
                            RageUI.ButtonWithStyle(string.format('[%s] %s [%s]', v.source, v.name, gamertage[v.group]), 'Job : ~o~'..v.jobs..'~s~', {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    ev.SelectedPlayer = v;
                                end
                            end, subAfterCo)
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("Aucun joueur en ligne.")
                        RageUI.Separator("")
                    end







            
        end, function()
        end)


        RageUI.IsVisible(subPerso,true,true,true,function()

            RageUI.ButtonWithStyle("~p~→~s~ Revive", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand('revive')
                end
            end)


            RageUI.ButtonWithStyle("~p~→~s~ Heal", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand('heal')
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ S'octroyer de l'argent cash", "ATTENTION : tout abus sera sévèrement puni", {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local cashEv = KeyboardInput("Combien ?","",20)
                    TriggerServerEvent('ev:giveCash', cashEv)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ S'octroyer de l'argent en Banque", "ATTENTION : tout abus sera sévèrement puni", {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local banqueEv = KeyboardInput("Combien ?","",20)
                    TriggerServerEvent('ev:giveBanque', banqueEv)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ S'octroyer de l'argent Sale", "ATTENTION : tout abus sera sévèrement puni", {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local SaleEv = KeyboardInput("Combien ?","",20)
                    TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(PlayerId()), 'item_money', 'rien', tonumber(SaleEv))
                end
            end)




            
        end, function()
        end)

        RageUI.IsVisible(subSanctions,true,true,true,function()



        
            RageUI.ButtonWithStyle("~p~→~s~ Warn", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local idWarn = KeyboardInput("Id :","",20)
                    local reasonWarn = KeyboardInput("Raison :","",100)
                    TriggerServerEvent('ev:setWarn', idWarn, reasonWarn)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Remoove Warn", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local idWarn = KeyboardInput("Id :","",20)
                    local number = KeyboardInput("Combien ou ALL = remise à 0","",20)
                    TriggerServerEvent('ev:remooveWarn', idWarn, number)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Kick", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local idK = KeyboardInput("Id :","",20)
                    local reasonK = KeyboardInput("Raison :","",50)
                    TriggerServerEvent('ev:kickjoueur', idK, reasonK)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Ban", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.ShowNotification("Entrez l'ID du joueur à bannir")
                    --ESX.ShowHelpNotification("Entrez le nom steam du joueur à débannir")
                    local idban = KeyboardInput("", "", '', 20)
                    ESX.ShowNotification("Entrez la durée du bannissement en jour pour le joueur avec l'id : " ..idban.."")
                    local idbanday = KeyboardInput("", "", '', 20)
                    ESX.ShowNotification("Vous allez bannir le joueur avec l'id : " ..idban.." pendant "..idbanday.." jours. Maintenant entrez la raison")
                    local raisonbanid = KeyboardInput("", "", '', 20)
                    ESX.ShowNotification("~b~Sanction - Bannissement\n~s~Joueur [ID] : " ..idban.."\nRaison : " ..raisonbanid.."\nDurée : " ..raisonbanid.."")
                    ExecuteCommand("sqlban "..idban.." " ..idbanday.." "..raisonbanid.."")
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ UnBan", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.ShowNotification("Entrez le nom steam du joueur à débannir")
                    --ESX.ShowHelpNotification("Entrez le nom steam du joueur à débannir")
                    local debanbb = KeyboardInput("", "", '', 20)
                    ExecuteCommand("sqlunban "..debanbb.." ")
                end
            end)

           




            
        end, function()
        end)

        RageUI.IsVisible(subVehicules,true,true,true,function()


            RageUI.ButtonWithStyle("~p~→~s~ Spawn un Véhicule", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local vehiStaffSp = KeyboardInput("Vehicule :", "",20)
                    local model = GetHashKey(vehiStaffSp)
                    RequestModel(model)
                    while not HasModelLoaded(model) do Citizen.Wait(50) end
                    local pos = GetEntityCoords(PlayerPedId())
                    vehicStaff = CreateVehicle(model, pos.x,pos.y,pos.z, 90, true, false)
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicStaff, -1)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Delete un Véhiucle", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local deVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    ESX.Game.DeleteVehicle(deVeh)
                    ESX.ShowNotification("Véhicule delete !")
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Changer la plaque", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local vehSt = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local newPl = KeyboardInput("Vehicule :", "",20)
                    SetVehicleNumberPlateText(vehSt, newPl)
                    ESX.ShowNotification("Plaque modifiée !")
                end
            end)


            RageUI.ButtonWithStyle("~p~→~s~ Couleur", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local vehSt = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local newColor = KeyboardInput("Rouge,Bleu,Blanc,Noir ou Vert", "",20)
                    if newColor == "Rouge" or newColor == "rouge" then
                        SetVehicleCustomPrimaryColour(vehSt, 255, 0, 0)
                        SetVehicleCustomSecondaryColour(vehSt, 255, 0, 0)
                    elseif newColor == "Bleu" or newColor == "bleu" then
                        SetVehicleCustomPrimaryColour(vehSt, 93, 182, 229)
                        SetVehicleCustomSecondaryColour(vehSt, 93, 182, 229)
                    elseif newColor == "Blanc" or newColor == "blanc" then
                        SetVehicleCustomPrimaryColour(vehSt, 255, 255, 255)
                        SetVehicleCustomSecondaryColour(vehSt, 255, 255, 255)
                    elseif newColor == "Noir" or newColor == "noir" then
                        SetVehicleCustomPrimaryColour(vehSt, 0, 0, 0)
                        SetVehicleCustomSecondaryColour(vehSt, 0, 0, 0)
                    elseif newColor == "Vert" or newColor == "vert" then
                        SetVehicleCustomPrimaryColour(vehSt, 114, 204, 114)
                        SetVehicleCustomSecondaryColour(vehSt, 114, 204, 114)
                    else
                        ESX.ShowNotification("Regarder Bien les couleurs admises")
                    end

                end
            end)


            RageUI.ButtonWithStyle("~p~→~s~ Réparer le véhicule", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)

                    SetVehicleFixed(car)
                    SetVehicleDirtLevel(car, 0.0)
                end
            end)




            RageUI.ButtonWithStyle("~p~→~s~ Full Custom le Véhicule", "Pas de retour arrière possible", {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    FullVehicleBoost()
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Donner le véhicule avec les clés", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    sortircaisse = {}
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('Personne autour de toi')
                    else 
                        local vehToGive = KeyboardInput("Vehicule à give au mec :", "",20)
                        chargementvoiture(vehToGive)
                        ESX.Game.SpawnVehicle(vehToGive, {x = -31.65111541748, y = -1091.4064941406, z = 26.422283172607}, 352.5824890136719, function(vehicle)
                        SetModelAsNoLongerNeeded(vehToGive)
                        SetVehicleNumberPlateText(vehToGive, Plaq)
                        table.insert(sortircaisse, vehToGive)
                        local vehicleProps = ESX.Game.GetVehicleProperties(sortircaisse[#sortircaisse])
                        end)
                        TriggerServerEvent('evStaff:Give', vehicleProps, GetPlayerServerId(closestPlayer))
                    end
                end
            end)




            
        end, function()
        end)

        RageUI.IsVisible(subAfterCo,true,true,true,function()

            ESX.TriggerServerCallback('ev:GetSteam', function(result)
                StockSteam = result
            end)

            for k, v in pairs(StockSteam) do
            RageUI.Separator("")
            RageUI.Separator("~y~"..v.name)
            RageUI.Separator("Id : ~p~"..ev.SelectedPlayer.source)
            RageUI.Separator("~o~"..v.steam)
            RageUI.Separator("")
            end

            RageUI.ButtonWithStyle("~p~→~s~ Envoyer un message", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local messageSt = KeyboardInput("Votre Message : ", "", 50)
                    TriggerServerEvent('ev:messageStaff', ev.SelectedPlayer.source, messageSt)
                end
            end)
            

            RageUI.ButtonWithStyle("~g~→~s~ Voir l'inventaire", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    getPlayerInv(GetPlayerFromServerId(ev.SelectedPlayer.source))
                end
            end, subInvActive)


            RageUI.ButtonWithStyle("~p~→~s~ Se télétporter sur le joueur", nil, {RightLabel = "→→"},true , function(_,_,s)
                if s then
                    ExecuteCommand("goto "..ev.SelectedPlayer.source)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Téléporter sur soi", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("bring "..ev.SelectedPlayer.source)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Kick", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local reasonK = KeyboardInput("Raison :","",50)
                    TriggerServerEvent('ev:kickjoueur', ev.SelectedPlayer.source, reasonK)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Ban", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.ShowNotification("Entrez la durée du bannissement en jour pour le joueur avec l'id : " ..ev.SelectedPlayer.source.."")
                    local idbanday = KeyboardInput("", "", '', 20)
                    ESX.ShowNotification("Vous allez bannir le joueur avec l'id : " ..ev.SelectedPlayer.source.." pendant "..idbanday.." jours. Maintenant entrez la raison")
                    local raisonbanid = KeyboardInput("", "", '', 20)
                    ESX.ShowNotification("~b~Sanction - Bannissement\n~s~Joueur [ID] : " ..ev.SelectedPlayer.source.."\nRaison : " ..raisonbanid.."\nDurée : " ..raisonbanid.."")
                    ExecuteCommand("sqlban "..ev.SelectedPlayer.source.." " ..idbanday.." "..raisonbanid.."")
                end
            end)




          
        end, function()
        end)

        RageUI.IsVisible(subStaff,true,true,true,function()


            if (#ev.PlayersStaff > 0) then
                for i, v in pairs(ev.PlayersStaff) do
                    local colors = {
                        ["_dev"] = '~r~',
                        ["superadmin"] = '~o~',
                        ["admin"] = '~b~',
                        ["modo"] = '~g~',
                    }
                    RageUI.ButtonWithStyle(string.format('%s[%s] %s', colors[v.group], v.source, v.name), nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ev.SelectedPlayerSt = v;
                        end
                    end, subStaff2)
                end
            else
                RageUI.Separator("")
                RageUI.Separator("Aucun staff en ligne.")
                RageUI.Separator("")
            end
            





            
        end, function()
        end)


        RageUI.IsVisible(subStaff2,true,true,true,function()



            RageUI.ButtonWithStyle("~g~→~s~ Voir l'inventaire", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    getPlayerInv(GetPlayerFromServerId(ev.SelectedPlayerSt.source))
                end
            end, subInvSt)

            RageUI.ButtonWithStyle("~p~→~s~ Changer le groupe", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local idForMe = ev.SelectedPlayerSt.source
                    local ChGr = KeyboardInput("Nouveau groupe", "", 20)
                    TriggerServerEvent('ev:ChangeGr', idForMe, ChGr)
                end
            end)

            RageUI.ButtonWithStyle("~p~→~s~ Tp sur moi", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local idForMe = ev.SelectedPlayerSt.source
                    ExecuteCommand("bring "..ev.SelectedPlayerSt.source)
                end
            end)


            RageUI.ButtonWithStyle("~p~→~s~ Se Tp sur lui", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local idForMe = ev.SelectedPlayerSt.source
                    ExecuteCommand("goto "..ev.SelectedPlayerSt.source)
                end
            end)





            
        end, function()
        end)

        RageUI.IsVisible(subInv,true,true,true,function()


            RageUI.Separator("~r~Inventaire de "..GetPlayerName(GetPlayerFromServerId(ev.SelectedPlayerSt.source)))
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                RageUI.Separator("↓ ~g~Money ~s~↓")

                for k,v  in pairs(ArgentBank) do
                    RageUI.ButtonWithStyle("Argent en banque :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
    
                for k,v  in pairs(ArgentCash) do
                    RageUI.ButtonWithStyle("Argent Liquide :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
    
                for k,v  in pairs(ArgentSale) do
                    RageUI.ButtonWithStyle("Argent sale :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
        
                RageUI.Separator("↓ ~y~Objets ~s~↓")

                for k,v  in pairs(Items) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "~r~x"..v.right}, true, function(_, _, s)
                    end)
                end

                RageUI.Separator("↓ ~r~Armes ~s~↓")
    
                for k,v  in pairs(Armes) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "avec ~r~"..v.right.. " ~s~balle(s)"}, true, function(_, _, s)
                    end)
                end




            
        end, function()
        end)

        RageUI.IsVisible(subInvSt,true,true,true,function()


            RageUI.Separator("~r~Inventaire de "..GetPlayerName(GetPlayerFromServerId(ev.SelectedPlayerSt.source)))
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                RageUI.Separator("↓ ~g~Money ~s~↓")

                for k,v  in pairs(ArgentBank) do
                    RageUI.ButtonWithStyle("Argent en banque :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
    
                for k,v  in pairs(ArgentCash) do
                    RageUI.ButtonWithStyle("Argent Liquide :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
    
                for k,v  in pairs(ArgentSale) do
                    RageUI.ButtonWithStyle("Argent sale :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
        
                RageUI.Separator("↓ ~y~Objets ~s~↓")

                for k,v  in pairs(Items) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "~r~x"..v.right}, true, function(_, _, s)
                    end)
                end

                RageUI.Separator("↓ ~r~Armes ~s~↓")
    
                for k,v  in pairs(Armes) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "avec ~r~"..v.right.. " ~s~balle(s)"}, true, function(_, _, s)
                    end)
                end




            
        end, function()
        end)

        RageUI.IsVisible(subInvActive,true,true,true,function()


            RageUI.Separator("~r~Inventaire de "..GetPlayerName(GetPlayerFromServerId(ev.SelectedPlayer.source)))
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                RageUI.Separator("↓ ~g~Money ~s~↓")

                for k,v  in pairs(ArgentBank) do
                    RageUI.ButtonWithStyle("Argent en banque :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
    
                for k,v  in pairs(ArgentCash) do
                    RageUI.ButtonWithStyle("Argent Liquide :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
    
                for k,v  in pairs(ArgentSale) do
                    RageUI.ButtonWithStyle("Argent sale :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
        
                RageUI.Separator("↓ ~y~Objets ~s~↓")

                for k,v  in pairs(Items) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "~r~x"..v.right}, true, function(_, _, s)
                    end)
                end

                RageUI.Separator("↓ ~r~Armes ~s~↓")
    
                for k,v  in pairs(Armes) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "avec ~r~"..v.right.. " ~s~balle(s)"}, true, function(_, _, s)
                    end)
                end




            
        end, function()
        end)
        


        RageUI.IsVisible(subKeyStaff,true,true,true,function()



            for i = 1, #Keys.evList, 1 do
                hash4 = Keys.evList[i].vehicle.model
                model4 = Keys.evList[i].vehicle
                nomvehicle4 = GetDisplayNameFromVehicleModel(hash4)
                text4 = GetLabelText(nomvehicle4)
                plaque4 = Keys.evList[i].plate 
    
                RageUI.ButtonWithStyle(text4, "Plaque : ~b~"..plaque4, {RightLabel = "🔑"}, true, function(Hovered, Active, Selected)
                end)
            end





            
        end, function()
        end)

        if not RageUI.Visible(StaffEV) and not RageUI.Visible(subReport) and not RageUI.Visible(subReport2) and not RageUI.Visible(subOptions) and not RageUI.Visible(subInfo) and not RageUI.Visible(subActivePly) and not RageUI.Visible(subPerso) and not RageUI.Visible(subSanctions) and not RageUI.Visible(subVehicules) and not RageUI.Visible(subAfterCo) and not RageUI.Visible(subStaff) and not RageUI.Visible(subStaff2) and not RageUI.Visible(subInv) and not RageUI.Visible(subInvSt) and not RageUI.Visible(subInvActive) and not RageUI.Visible(subKeyStaff) then
            StaffEV=RMenu:DeleteType("StaffEV", true)
        end

    end

end

Keys = {
    evList = {},
}


----- Reports


RegisterCommand('report', function()
    OpenReportMenu()
end)


function OpenReportMenu()

    local evReport = RageUI.CreateMenu(Config.UrServ,"report")

    RageUI.Visible(evReport, not RageUI.Visible(evReport))

    while evReport do
        
        Citizen.Wait(0)

        RageUI.IsVisible(evReport,true,true,true,function()



        
            
                RageUI.ButtonWithStyle("Faire un report", nil, {RightLabel = "~p~→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        inside = KeyboardInput("Votre problème", "", 500)
                        nameduCouz = GetPlayerName(PlayerId())
                        TriggerServerEvent('ev:report', nameduCouz, inside)
                        ESX.ShowNotification("Votre report a bien été transféré !")
                        RageUI.CloseAll()
                    end
                end)




            
        end, function()
        end)

        if not RageUI.Visible(evReport) then
            evReport=RMenu:DeleteType("evReport", true)
        end

    end

end





------------------Keyboard INPUT


KeyboardInput = function(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end



----- Get les Notifs pour chaque report

RegisterNetEvent("ev:sendNotifForReport")
AddEventHandler("ev:sendNotifForReport", function(type, nomdumec)
    evActu()
    if type == 1 then
        ESX.TriggerServerCallback('ev:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(evNotifR) do
                if playergroup == v then
                ESX.ShowNotification('🔴 Vous avez un nouveau Report !')
                end
            end
        end)
    end
end)


function evActu()
    ESX.TriggerServerCallback('ev:GetRep', function(result)
        reportCLi = result
    end)
    print("actualisé")
    
end

--- Commande et function spectt


RegisterCommand("spect", function(source, args, rawCommand) 
    ESX.TriggerServerCallback('ev:getUsergroup', function(group)
    playergroup = group
    if playergroup == 'superadmin' or playergroup == 'owner' then
    idnum = tonumber(args[1])
    local playerId = GetPlayerFromServerId(idnum)
    SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
    else
      RageUI.Popup({message = "Vous n'avez pas accès à cette commande"})  
    end
  end)
end)


function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end



function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end


function SpectatePlayer(targetPed,target,name)
    local playerPed = PlayerPedId() 
	enable = true
	if targetPed == playerPed then enable = false end

    if(enable)then
        
        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(true, targetPed)
		DrawPlayerInfo(target)
        RageUI.Popup({message = "~g~Mode spectateur en cours"})
    else

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nN'est plus entrain de spectate "..name)
        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(false, targetPed)
		StopDrawPlayerInfo()
        RageUI.Popup({message = "~b~Mode spectateur arrêtée"})
    end
end




---- Commande /tpm 



RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" or playerRank == "owner" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end

                ESX.ShowNotification("Teleported.")
            else
                ESX.ShowNotification("Place un point")
            end
        else
            ESX.ShowNotification("Vous n'avez pas ce droit")
        end
    end)
end



----- Show name 


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		if ShowName then
			local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
			for _, v in pairs(GetActivePlayers()) do
				local otherPed = GetPlayerPed(v)
                local job = ESX.PlayerData.job.name
                local job2 = ESX.PlayerData.job2.name

				if otherPed ~= pPed then
					if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, (" ["..GetPlayerServerId(v).."] "..GetPlayerName(v).." \nJobs : "..job.." / "..job2), false, false, '', 0)
						SetMpGamerTagVisibility(gamerTags[v], 4, 1)
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
		else
			for _, v in pairs(GetActivePlayers()) do
				RemoveMpGamerTag(gamerTags[v])
			end
		end
    end
end)






----------- Noclip 

local noclip = false
local noclip_speed = 1.5



function getPosition()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	return x,y,z
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()

	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)

	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x,y,z
end

function isNoclip()
	return noclip
end


RegisterCommand("noclip", function()
	local player = PlayerId()
	local ped = PlayerPedId
	
	local msg = "desactivado"
	if(noclip == false)then
	end

	noclip = not noclip

	if(noclip)then
		msg = "activado"
	end

	TriggerEvent("chatMessage", "Noclip ^2^*" .. msg)
		SetEntityVisible(GetPlayerPed(-1), true, 0)

	end)

	local heading = 0
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if noclip then
			local ped = GetPlayerPed(-1)
			local x,y,z = getPosition()
			local dx,dy,dz = getCamDirection()
			local speed = noclip_speed

			SetEntityVisible(GetPlayerPed(-1), false, 0)


			SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)


		if IsControlPressed(0,32) then -- MOVE adelante
			x = x+speed*dx
			y = y+speed*dy
			z = z+speed*dz
		end

		if IsControlPressed(0,269) then -- MOVE atras
			x = x-speed*dx
			y = y-speed*dy
			z = z-speed*dz
		end

		if IsControlPressed(0,34) then -- MOVE IZQ
			x = x-1
		end

		if IsControlPressed(0,9) then -- MOVE DERCH
			x = x+1
		end

		if IsControlPressed(0,203) then -- MOVE arriba
			z = z+1
		end

		if IsControlPressed(0,210) then -- MOVE arriba
			z = z-1
		end

		if IsControlPressed(0,21) then
			noclip_speed = 3.0
		else
			noclip_speed = 1.5
		end


		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
		end
	end
end)




-- Full Custom 

function FullVehicleBoost()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 14, 0, true)
        SetVehicleNumberPlateTextIndex(vehicle, 5)
        ToggleVehicleMod(vehicle, 18, true)
        SetVehicleColours(vehicle, 0, 0)
        SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
        SetVehicleModColor_2(vehicle, 5, 0)
        SetVehicleExtraColours(vehicle, 111, 111)
        SetVehicleWindowTint(vehicle, 3)
        ToggleVehicleMod(vehicle, 22, true)
        SetVehicleMod(vehicle, 23, 11, false)
        SetVehicleMod(vehicle, 24, 11, false)
        SetVehicleWheelType(vehicle, 120)
        SetVehicleWindowTint(vehicle, 3)
        ToggleVehicleMod(vehicle, 20, true)
        SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
        LowerConvertibleRoof(vehicle, true)
        SetVehicleIsStolen(vehicle, false)
        SetVehicleIsWanted(vehicle, false)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetCanResprayVehicle(vehicle, true)
        SetPlayersLastVehicle(vehicle)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleTyresCanBurst(vehicle, false)
        SetVehicleWheelsCanBreak(vehicle, false)
        SetVehicleCanBeTargetted(vehicle, false)
        SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
        SetVehicleHasStrongAxles(vehicle, true)
        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleCanBeVisiblyDamaged(vehicle, false)
        IsVehicleDriveable(vehicle, true)
        SetVehicleEngineOn(vehicle, true, true)
        SetVehicleStrong(vehicle, true)
        RollDownWindow(vehicle, 0)
        RollDownWindow(vehicle, 1)
        SetPedCanBeDraggedOut(PlayerPedId(), false)
        SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
        SetPedRagdollOnCollision(PlayerPedId(), false)
        ResetPedVisibleDamage(PlayerPedId())
        ClearPedDecorations(PlayerPedId())
        SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
    end
end





testVehEv = {}

RegisterNetEvent('evStaff:Create2')
AddEventHandler('evStaff:Create2', function(Voit, pl)
    local pos = GetEntityCoords(PlayerId())
    local evCar = Voit
    local Plaq = pl
    chargementvoiture(evCar)
    ESX.Game.SpawnVehicle(evCar, {x = pos.x, y = pos.y, z = pos.z}, 90, function(vehicle)
    SetModelAsNoLongerNeeded(evCar)
    SetVehicleNumberPlateText(vehicle, Plaq)
    table.insert(testVehEv, vehicle)
    local vehicleProps = ESX.Game.GetVehicleProperties(testVehEv[#testVehEv])
    TriggerServerEvent('ev:fix', Plaq, vehicleProps)
    end)
end)



function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('Chargement du véhicule')
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end




RegisterCommand("announceEV", function(source, args)
    TriggerServerEvent("announceEV", table.concat(args, " "))
end)




------------ Get PlayerData 

function getPlayerInv(player)
    
    Items = {}
    Armes = {}
    ArgentSale = {}
    ArgentCash = {}
    ArgentBank = {}
    
    ESX.TriggerServerCallback('ev:getOtherPlayerData', function(data)
    
    
        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'bank' and data.accounts[i].money > 0 then
                table.insert(ArgentBank, {
                    label    = ESX.Math.Round(data.accounts[i].money),
                    value    = 'bank',
                    itemType = 'item_bank',
                    amount   = data.accounts[i].money
                })
    
                break
            end
        end
    
    
        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'money' and data.accounts[i].money > 0 then
                table.insert(ArgentCash, {
                    label    = ESX.Math.Round(data.accounts[i].money),
                    value    = 'money',
                    itemType = 'item_cash',
                    amount   = data.accounts[i].money
                })
    
                break
            end
        end
    
        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                table.insert(ArgentSale, {
                    label    = ESX.Math.Round(data.accounts[i].money),
                    value    = 'black_money',
                    itemType = 'item_account',
                    amount   = data.accounts[i].money
                })
    
                break
            end
        end
    
        for i=1, #data.weapons, 1 do
            table.insert(Armes, {
                label    = ESX.GetWeaponLabel(data.weapons[i].name),
                value    = data.weapons[i].name,
                right    = data.weapons[i].ammo,
                itemType = 'item_weapon',
                amount   = data.weapons[i].ammo
            })
        end
    
        for i=1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(Items, {
                    label    = data.inventory[i].label,
                    right    = data.inventory[i].count,
                    value    = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount   = data.inventory[i].count
                })
            end
        end
    end, GetPlayerServerId(player))
end



----- Joueur Connectés 

ServersIdSession = {}

Citizen.CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(GetActivePlayers()) do
            local found = false
            for _,j in pairs(ServersIdSession) do
                if GetPlayerServerId(v) == j then
                    found = true
                end
            end
            if not found then
                table.insert(ServersIdSession, GetPlayerServerId(v))
            end
        end
    end
end)



-------- Give veh 



function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('Chargement du véhicule')
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end




function supprimervehiculeconcess()
	while #sortircaisse > 0 do
		local vehicle = sortircaisse[1]

		ESX.Game.DeleteVehicle(sortircaisse)
		table.remove(sortircaisse, 1)
	end
end