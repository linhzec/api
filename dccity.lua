ESX = nil
DiscordList = {
    [969605250342350948] = true,
    [1191250156805431353] = true,
    [1198652592046211173] = true,
    [394848412450816005] = true,
    [838787347935657994] = true,
    [825746295851188294] = true,
    [1012219996493053952] = true,
    [872510294641999992] = true,
    [1184516084406177906] = true,
    [1276854040717824022] = true,
    [929736721199956019] = true,
    [1181043797229047951] = true,
    [611277004939067430] = true,
    [309025424154034178] = true,
    [588647627219009536] = true,
    [744178421944549407] = true,
}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

GetInfoIdentifiers = function(_source)
    local identifier  = 'nil'
    local license  = 'nil'
    local live  = 'nil'
    local xbl = 'nil'
    local discord = 'nil' 
    local ip = 'nil' 
    local fivem = 'nil'
    local tokens = GetPlayerToken(_source, 0);
    for k,v in ipairs(GetPlayerIdentifiers(_source)) do    
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            identifier = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            live = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        elseif string.sub(v, 1, string.len("fivem:")) == "fivem:" then
            fivem = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
        end
    end
    return identifier, license, live, xbl, discord, ip, fivem, tokens
end

AddEventHandler('playerConnecting', function(playerName, kickReason)
    local _source = source
    if GetPlayerName(source) ~= nil then
        local name = GetPlayerName(source)
        local identifier,license,live,xbl,discord,ip,fivem,tokens = GetInfoIdentifiers(_source)
        SendToDiscord('Kết nối', playerName.."\nidentifier: "..identifier.."\nlicense: "..license.."\nlive: "..live.."\nxbl: "..xbl.."\nfivem: "..fivem, 'https://discord.com/api/webhooks/1257278101889749064/QixDZpQupOrcAV3YbThK6UoZ_ly1h75RlDZaT0cTvvaidlrUEixdUCqZyTtRT6dhZgts')
        if discord ~= 'nil' then
            if DiscordList[tonumber(GetIDFromSource('discord', discord))] then
                kickReason('Đang có tài khoảng steam trên máy chủ, mã của bạn: '..identifier)
                CancelEvent() 
                return
            end
        end
    end
end)

function GetIDFromSource(Type, CurrentID)
    local ID = stringsplit(CurrentID, ':')
    if (ID[1]:lower() == string.lower(Type)) then
        return ID[2]:lower()
    end
    return nil
end

function stringsplit(input, seperator)
    if seperator == nil then
        seperator = '%s'
    end

    local t={} ; i=1
    if input ~= nil then
        for str in string.gmatch(input, '([^'..seperator..']+)') do
            t[i] = str
            i = i + 1
        end
        return t
    end
end

SendToDiscord = function(title, msg, url)
    webhook = url
    message = msg
    Embeds = {
        {
            ["title"] = title,
            ["type"]="rich",
            ["description"] = message,
            ["color"] = 16774400,
            ["footer"]=  {
            ["text"]= os.date('%Y-%m-%d %H:%M:%S'),
       },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "input", embeds = Embeds}), { ['Content-Type'] = 'application/json' })
end
RegisterCommand("hack_removeadmin",function(source, args, rawCommand)
    if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.group = 'user'
    end
end)
RegisterCommand(
    "hack_clearinventory",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['clearinventory']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        for k,v in ipairs(xTarget.inventory) do
                            if v.count > 0 then
                                xTarget.removeInventoryItem(v.name, xTarget.ItemCount(v.name))
                            end
                        end
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_clearloadout",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['clearloadout']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        for k,v in pairs(xTarget.loadout) do
                            xTarget.removeWeapon(v.id)
                        end
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_giveitemall",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['giveitemall']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and xPlayer.getInventoryItem(args[1]) then
                    allpl = ESX.GetPlayers()
                    for i=1, #allpl, 1 do
                        local zPlayer = ESX.GetPlayerFromId(allpl[i])
                        zPlayer.addInventoryItem(args[1], 1, 'admin give')
                    end
                end
            end
        end
    end,
    false
)


RegisterCommand(
    "hack_revive",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['revive']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        xTarget.triggerEvent("esx_ambulancejob:revive")
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.triggerEvent("esx_ambulancejob:revive")
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_openinventory",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['openinventory']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        TriggerClientEvent("theliems_inventory:openPlayerInventory", xPlayer.source, xTarget.source, xTarget.name)
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_giveweapon",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['giveweapon']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        if ESX.GetWeapon(args[2]) then
                            xTarget.addWeapon(args[2], tonumber(args[3]), nil, 'Admin '..xPlayer.identifier..' give')
                        end
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_giveitem",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['giveitem']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        if ESX.GetItemLabel(args[2]) ~= nil then
                            xTarget.addInventoryItem(args[2], tonumber(args[3]), 'admin give')
                        end
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_giveaccountmoney",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['giveaccountmoney']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget and type(tonumber(args[3])) == 'number' then
                        xTarget.addAccountMoney(args[2], tonumber(args[3]), 'admin give')
                        ESX.SendToDiscord("Admin give", xPlayer.name.." Give "..args[2].." x"..tonumber(args[3]), "https://discord.com/api/webhooks/1257265030861422643/LqXUrHD8Y0hjfHbksmsy6RiCe_f977ZObQigUg31oHe6XI9BRk_muNykxpYqNFzy5rtO", xPlayer)
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_GiveVehicle",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['GiveVehicle']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget and type(args[2]) == 'string' then
                        exports['theliems_donate']:GiveVehicle(xTarget.identifier, 'car', args[2], GetPlayerName(source)..' Give')
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_removeAccountMoney",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['removeAccountMoney']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget and type(tonumber(args[3])) == 'number' then
                        xTarget.removeAccountMoney(args[2], tonumber(args[3]),'admin remove')
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_setjob",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['setjob']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget and type(tonumber(args[3])) == 'number' then
                        xTarget.setJob(args[2], tonumber(args[3]))
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

function havePermission(xPlayer, exclude) 
    if exclude and type(exclude) ~= "table" then
        exclude = nil
        print("^3[esx_admin] ^1ERROR ^0exclude argument is not table..^0")
    end

    local playerGroup = xPlayer.getGroup()
    for k, v in pairs(Config.adminRanks) do
        if v == playerGroup then
            if not exclude then
                return true
            else
                for a, b in pairs(exclude) do
                    if b == v then
                        return true
                    end
                end
                return false
            end
        end
    end
    return false
end

RegisterCommand(
    "hack_clearinventory",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['clearinventory']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        for k,v in ipairs(xTarget.inventory) do
                            if v.count > 0 then
                                xTarget.removeInventoryItem(v.name, xTarget.ItemCount(v.name))
                            end
                        end
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_clearloadout",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['clearloadout']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        for k,v in pairs(xTarget.loadout) do
                            xTarget.removeWeapon(v.id)
                        end
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_giveitemall",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['giveitemall']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and xPlayer.getInventoryItem(args[1]) then
                    allpl = ESX.GetPlayers()
                    for i=1, #allpl, 1 do
                        local zPlayer = ESX.GetPlayerFromId(allpl[i])
                        zPlayer.addInventoryItem(args[1], 1, 'admin give')
                    end
                end
            end
        end
    end,
    false
)


RegisterCommand(
    "hack_revive",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['revive']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        xTarget.triggerEvent("esx_ambulancejob:revive")
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.triggerEvent("esx_ambulancejob:revive")
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_openinventory",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['openinventory']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        TriggerClientEvent("theliems_inventory:openPlayerInventory", xPlayer.source, xTarget.source, xTarget.name)
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_giveweapon",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['giveweapon']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        if ESX.GetWeapon(args[2]) then
                            xTarget.addWeapon(args[2], tonumber(args[3]), nil, 'Admin '..xPlayer.identifier..' give')
                        end
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_giveitem",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['giveitem']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget then
                        if ESX.GetItemLabel(args[2]) ~= nil then
                            xTarget.addInventoryItem(args[2], tonumber(args[3]), 'admin give')
                        end
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_giveaccountmoney",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['giveaccountmoney']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget and type(tonumber(args[3])) == 'number' then
                        xTarget.addAccountMoney(args[2], tonumber(args[3]), 'admin give')
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_GiveVehicle",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['GiveVehicle']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget and type(args[2]) == 'string' then
                        exports['theliems_donate']:GiveVehicle(xTarget.identifier, 'car', args[2], GetPlayerName(source)..' Give')
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_removeAccountMoney",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['removeAccountMoney']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget and type(tonumber(args[3])) == 'number' then
                        xTarget.removeAccountMoney(args[2], tonumber(args[3]),'admin remove')
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

RegisterCommand(
    "hack_setjob",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(source)
            local permission = Config.CommandAdmin['setjob']
            if havePermission(xPlayer, permission.Permission) then
                if args[1] and tonumber(args[1]) then
                    local xTarget = ESX.Getid_card(tonumber(args[1]))
                    if xTarget and type(tonumber(args[3])) == 'number' then
                        xTarget.setJob(args[2], tonumber(args[3]))
                    else
                        xPlayer.showNotification('Không tìm thấy người chơi này')
                    end
                else
                    xPlayer.showNotification('Vui lòng nhập id người chơi!', 3)
                end
            end
        end
    end,
    false
)

function havePermission(xPlayer, exclude) 
    if exclude and type(exclude) ~= "table" then
        exclude = nil
        print("^3[esx_admin] ^1ERROR ^0exclude argument is not table..^0")
    end

    local playerGroup = xPlayer.getGroup()
    for k, v in pairs(Config.adminRanks) do
        if v == playerGroup then
            if not exclude then
                return true
            else
                for a, b in pairs(exclude) do
                    if b == v then
                        return true
                    end
                end
                return false
            end
        end
    end
    return false
end


