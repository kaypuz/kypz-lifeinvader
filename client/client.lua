local QBCore = exports['qb-core']:GetCoreObject()
local sellstart = false

AddEventHandler('onResourceStart', function(resource) --if you restart the resource
    if resource == GetCurrentResourceName() then
        Wait(200)
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

CreateThread(function()
    local enterZone = false
    local Notify = nil
    local PlayerJob = {}
    while true do
        local sleep = 1250
        local inZone = false
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        local coords = GetBlipInfoIdCoord(sellblip)
        local lifehtmlDist = #(PlayerPos - Config.LifeMarker["lifehtml"])
        local lifecssDist = #(PlayerPos - Config.LifeMarker["lifecss"])
        local lifejavaDist = #(PlayerPos - Config.LifeMarker["lifejava"])
        local lifeDist = #(PlayerPos - Config.LifeMarker["lifeyazilim"])
        local lifepackedDist = #(PlayerPos - Config.LifeMarker["lifepaket"])
        local LifeSell = #(PlayerPos - Config.LifeMarker["lifepaket"])
        local lifeDelivery = #(PlayerPos - vec3(coords[1], coords[2], coords[3]))
        local pressedKeyE = IsControlJustPressed(0, 38)
        if lifehtmlDist < 1 then sleep = 5 inZone  = true 
            Notify = 'LifeHtml' if pressedKeyE then addItem(15000,"lifehtml") end
        end
        if lifecssDist < 1 then sleep = 5 inZone  = true  
            Notify = 'LifeCss' if pressedKeyE then  addItem(20000,"lifecss") end
        end
        if lifejavaDist < 1 then sleep = 5 inZone  = true 
            Notify = 'LifeJava' if pressedKeyE then addItem(25000,"lifejava") end
        end
        if lifeDist < 1 then sleep = 5 inZone  = true 
            Notify = 'LifeYazilim' if pressedKeyE then checkLife("lifeyazilim") end
        end
        if lifepackedDist < 1 then sleep = 5 inZone  = true 
            Notify = 'Paketlenmiş Yazılım' if pressedKeyE then checkItem("lifeyazilim","lifepaket") end
        end
        if LifeSell < 1 then sleep = 5 inZone  = true 
            Notify = 'Sipariş Al' if pressedKeyE then sellLife("lifepaket") end
        end
        if lifeDelivery < 4 and sellstart then sleep = 5
            DrawMarker(2, coords[1], coords[2], coords[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 225, 138, 21, 200, 0, 0, 0, 1, 0, 0, 0)
            if lifeDelivery < 1 then inZone  = true 
               Notify = 'Teslim Et' if pressedKeyE then checkDelivery("lifepaket") end
         end
    end
        if inZone and not enterZone then
            enterZone = true
            TriggerEvent('text:show', "<b style='color:#44e467;'>[E] </b>"..Notify, "")
        end
        if not inZone and enterZone then
            enterZone = false
            TriggerEvent('text:hide')
        end
        Wait(sleep)
    end
end)

addItem = function(time,additem) 
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar("lifein","Kod Yazılıyor", time, false, true, 
        {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, 
        {animDict = "mp_arresting",anim = "a_uncuff",flags = 49,}, {}, {}, function() -- Done
        StopAnimTask(ped, "mp_arresting", "a_uncuff", 1.0)
        TriggerServerEvent('kypz-lifeinvader:server:additem',additem)
    end)
end

checkItem = function(checkitem,additem)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(cb)  
        if cb then
            TriggerServerEvent('kypz-lifeinvader:server:removeitem',checkitem)
            addItem(8000,additem) 
        else
            QBCore.Functions.Notify("Sahip değilsin "..checkitem, "error")
        end
    end,checkitem)
end

checkLife = function(additem)
    QBCore.Functions.TriggerCallback('kypz-lifeinvader:server:checkLife', function(cb)  
        if cb then
            addItem(8000,additem) 
        else
            QBCore.Functions.Notify("Yeteri kadar malzemen yok..", "error")
        end
    end)
end


sellLife = function(checkitem)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(cb)  
        if cb and not sellstart then
            local random = math.random(1,#Config.Locations)
            sellcoords = {x = Config.Locations[random][1],y = Config.Locations[random][2],z = Config.Locations[random][3],h = Config.Locations[random][4]}
            sellblip = CreateSellBlip(sellcoords.x, sellcoords.y, sellcoords.z)
            SetNewWaypoint(sellcoords.x, sellcoords.y)
            sellstart = true
            QBCore.Functions.Notify("Yeni adres GPS işaretlendi", "success")
        else
            QBCore.Functions.Notify("Yeterli malzemen yok veya "..checkitem.." aktif siparişin var", "error")
        end
    end,checkitem)
end

checkDelivery = function(checkitem)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(cb)  
        if cb and sellstart then
            local ped = PlayerPedId()
            QBCore.Functions.Progressbar("delivery","Hop", 6000, false, true, 
            {disableMovement = true,disableCarMovement = true,disableMouse = false, disableCombat = true,}, 
            {animDict = "mp_common",anim = "givetake1_a",flags = 49,}, {}, {}, function() -- Done
            StopAnimTask(ped, "mp_common", "givetake1_a", 1.0)
            RemoveBlip(sellblip) 
            TriggerServerEvent('kypz-lifeinvader:server:removeitem',checkitem) 
            TriggerServerEvent('kypz-lifeinvader:server:givemoney')
            sellstart = false 
        end)
        else
            QBCore.Functions.Notify("Sahip değilsin "..checkitem, "error")
        end
    end,checkitem)
end

CreateSellBlip = function(x,y,z)
	local blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip, 489)
	SetBlipColour(blip, 1)
	AddTextEntry('MYBLIP', "Siparişi Götür")
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	return blip
end

-- CreateThread(function()
--     local modelHash = GetHashKey("u_f_o_eileen")
--     RequestModel(modelHash)
--       while not HasModelLoaded(modelHash) do
--         Wait(10)
--       end
--     local ped = CreatePed(4, modelHash, 9.95, -1604.68, 28.38, 230.2, false, false)
--     SetEntityInvincible(ped, true)
--     SetBlockingOfNonTemporaryEvents(ped, true)
--     FreezeEntityPosition(ped, true)
--     local blip = AddBlipForCoord(12.92127, -1602.86, 29.374)
--     SetBlipSprite(blip, 208)
--     SetBlipAsShortRange(blip, true)
--     SetBlipScale(blip, 0.6)
--     SetBlipColour(blip, 44)
--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString("Life")
--     EndTextCommandSetBlipName(blip)
-- end)
