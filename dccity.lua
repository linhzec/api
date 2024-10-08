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
