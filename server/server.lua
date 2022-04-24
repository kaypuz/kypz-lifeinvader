local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('kypz-lifeinvader:server:additem', function(additem)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(additem, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[additem], "add")
end)

RegisterNetEvent('kypz-lifeinvader:server:removeitem', function(removeitem)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(removeitem, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[removeitem], "remove")
end)

RegisterNetEvent('kypz-lifeinvader:server:givemoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tiprandom = math.random(1,50)
    local lifemoney = math.random(Config.LifeMoneyMin,Config.LifeMoneyMax)
    Player.Functions.AddMoney("cash", lifemoney, "life-money")
    TriggerClientEvent('QBCore:Notify', src, "Yazılımı teslim ettin! Yeni sipariş için şubeye dönmelisin.", "success")
    TriggerClientEvent('QBCore:Notify', src, "Kazandın $"..lifemoney)
    if tiprandom >= 25 then
        Player.Functions.AddMoney("cash", Config.LifeTip, "life-tip")
        TriggerClientEvent('QBCore:Notify', src, "Bahşiş kazandın $"..Config.LifeTip)
    end
end)

QBCore.Functions.CreateCallback('kypz-lifeinvader:server:checkLife', function(source, cb)
    local src = source
    local Player =  QBCore.Functions.GetPlayer(src)
    local lifehtml = Player.Functions.GetItemByName("lifehtml")
    local lifecss = Player.Functions.GetItemByName("lifecss")
    local lifejava = Player.Functions.GetItemByName("lifejava")
    if lifehtml ~= nil and lifecss ~= nil  and lifejava ~= nil then
        Player.Functions.RemoveItem("lifehtml", 1)
        Player.Functions.RemoveItem("lifecss", 1)
        Player.Functions.RemoveItem("lifejava", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["lifehtml"], "remove")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["lifecss"], "remove")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["lifejava"], "remove")
        cb(true)
    else
        cb(false)
    end
end)