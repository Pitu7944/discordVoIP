--[[ edited (22.09.2020) by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]
Config = {}
Config.debugEnable = false
Config.apiKey = "" -- your discord_module and request_handler api key! (config.py)
Config.apiServer = "" -- your request_handler ip (config.py)
Config.apiPort = "" -- yout request_handler port (config.py)
Config.lobbyChannelid = 12345678901987654 -- your lobby discord channel id (turn developer mode on, right click and copy id)
Config.Channels = { -- configure your channels like the examples here!
    {
        name = "lspd_88_0MHZ", -- chanel name (doesn't change the discord channel name)
        id = 1, -- id for channel in radio, must be unique
        job = 'policja', -- job for using channel
        job_restricted = true, -- if channel is job restricted
        dest_id = 12345678901987654 -- discord channel id (turn developer mode on, right click and copy id)
    },
    {
        name = "lspd_88_1MHZ",
        id = 2,
        job_restricted = true,
        job = "policja",
        dest_id = 12345678901987654
    }
}
-- loading of main database and shit
local apiUrl = "http://"..tostring(Config.apiServer)..":"..tostring(Config.apiPort).."/moveMember" -- url prepping for the api
local loadFile = LoadResourceFile(GetCurrentResourceName(), "./playerDB.json") -- load db file
local playerDB = {} -- initialize db dict
playerDB = json.decode(loadFile) -- load db as json
--[[
DiscordVoIP made by Pitu7944#2711
]]
RegisterNetEvent('discordVoIP:radio')
AddEventHandler('discordVoIP:radio', function(args)
    local destination
    if args[1] == 'off' then 
        destination = Config.lobbyChannelid
    if args[1] == 'on' then 
        destination = Config.lobbyChannelid
    elseif args[1] == 'kick' then 
        destination = 00000000000
    elseif args[1] == 'link' then
        local identifier = GetPlayerIdentifier(source, 'steam')
        --local identifier = 'steam:test123' // test
        if args[2] ~= nil then
            link_discord(identifier, args[2])
        else
            dprint("No clientID specified!")
        end
    elseif args[1] == 'unlink' then
        local identifier = GetPlayerIdentifier(source, 'steam')
        --local identifier = 'steam:test123' // test 
        unlink_discord(identifier)
    else
        dprint(apiUrl)
        dprint(args[1])
        if tonumber(args[1]) == 0 then
            destination = Config.lobbyChannelid
        else
            local channel = get_channelObject(args[1])
            if source ~= 0 then
                local xPlayer = ESX.GetPlayerFromID(source)
                if xPlayer.job.name == channel.job and channel.job_restricted == true then
                    dprint("Job Correct joining channel!")
                    if channel ~= nil then destination = channel.dest_id else destination = Config.lobbyChannelid end
                elseif xPlayer.job.name ~= channel.job and channel.job_restricted == true then
                    dprint("Job not Correct, returning to lobby!")
                    destination = Config.lobbyChannelid
                else
                    if channel ~= nil then destination = channel.dest_id else destination = Config.lobbyChannelid end
                end
            else
                if channel ~= nil then destination = channel.dest_id else destination = Config.lobbyChannelid end
            end
        end
    end
    if destination == nil then destination = 000000000000000 end
    if args[1] ~= 'link' and args[1] ~= 'unlink' then 
        PerformHttpRequest(apiUrl, function(errorCode, result) end, 'POST', json.encode({api_key = Config.apiKey ,member_id = 252387151457681410, channel_id = destination}), {['Content-Type'] = 'application/json'})
    end
end)

RegisterCommand('radio', function(source, args, rawCommand)
    local destination
    if args[1] == 'off' then 
        destination = Config.lobbyChannelid
    if args[1] == 'on' then 
        destination = Config.lobbyChannelid
    elseif args[1] == 'kick' then 
        destination = 00000000000
    elseif args[1] == 'link' then
        local identifier = GetPlayerIdentifier(source, 'steam')
        --local identifier = 'steam:test123'
        if args[2] ~= nil then
            link_discord(identifier, args[2])
        else
            dprint("No clientID specified!")
        end
    elseif args[1] == 'unlink' then
        local identifier = GetPlayerIdentifier(source, 'steam')
        --local identifier = 'steam:test123'
        unlink_discord(identifier)
    else
        dprint(apiUrl)
        dprint(args[1])
        if tonumber(args[1]) == 0 then
            destination = Config.lobbyChannelid
        else
            local channel = get_channelObject(args[1])
            if source ~= 0 then
                local xPlayer = ESX.GetPlayerFromID(source)
                if xPlayer.job.name == channel.job and channel.job_restricted == true then
                    dprint("Job Correct joining channel!")
                    if channel ~= nil then destination = channel.dest_id else destination = Config.lobbyChannelid end
                elseif xPlayer.job.name ~= channel.job and channel.job_restricted == true then
                    dprint("Job not Correct, returning to lobby!")
                    destination = Config.lobbyChannelid
                else
                    if channel ~= nil then destination = channel.dest_id else destination = Config.lobbyChannelid end
                end
            else
                if channel ~= nil then destination = channel.dest_id else destination = Config.lobbyChannelid end
            end
        end
    end
    if destination == nil then destination = 000000000000000 end
    if args[1] ~= 'link' and args[1] ~= 'unlink' then 
        PerformHttpRequest(apiUrl, function(errorCode, result) end, 'POST', json.encode({api_key = Config.apiKey ,member_id = 252387151457681410, channel_id = destination}), {['Content-Type'] = 'application/json'})
    end
end, false)

RegisterCommand('loadPlayerDB', function() load_playerDB() end, false)

RegisterCommand('checkClientID', function(source, args)
    dprint(find_clientID(args[1]))
end, false)

-- debug functions:
function dprint(txt)
    if Config.debugEnable == true then
        print("^4[DEBUG] ^2"..tostring(txt))
    end
end

function get_channelID(id) -- gets the discord channel id from config and returns it
    dprint("searching for id: "..id)
    for _, Channel in pairs(Config.Channels) do 
        if (Channel.id == tonumber(id)) then
            dprint("Found: "..Channel.dest_id)
            return(Channel.dest_id)
        end
    end
end

function get_channelObject(id)
    dprint('[get_channelObject] Searching for channel with id: '..id)
    for _, Channel in pairs(Config.Channels) do 
        if (Channel.id == tonumber(id)) then
            dprint("[get_channelObject] Found: "..tostring(Channel.name))
            return(Channel)
        end
    end
end

function link_discord(identifier, clientID) -- links steam identifier to discord client id
    dprint('[link_discord] Trying to link '..identifier)
    local identifiers = {}
    for _, Player in pairs(playerDB) do
        addToSet(identifiers, Player.identifier)
    end
    if setContains(identifiers, identifier) then dprint("[link_discord] linking Failed") return end
    dprint('[link_discord] Linking '..tostring(clientID).." with "..identifier)
    template = {identifier = identifier, clientID = clientID}
    table.insert(playerDB, template)
    savePlayers()
end

function unlink_discord(identifier, clientID) -- unlinks discord client id from steam identifier
    dprint('[unlink_discord] Trying to unlink '..identifier)
    local identifiers = {}
    for _, Player in pairs(playerDB) do
        addToSet(identifiers, Player.identifier)
    end
    if setContains(identifiers, identifier) then
        table.remove(playerDB, find_PlayerOBJECT(identifier))
        dprint("[unlink_discord] Discord Succesfully unlinked!")
        savePlayers()
    end
end

function savePlayers()
    SaveResourceFile(GetCurrentResourceName(), "playerDB.json", json.encode(playerDB), -1)
end

function find_PlayerOBJECT(identifier) -- return player index from playerDB
    dprint("[find_Player] Searching for Player associated with : "..identifier)
    local playerSET = {}
    for i, Player in pairs(playerDB) do
        if Player.identifier == identifier then
            return i
        end
    end
end

function find_clientID(identifier) -- returns client id associated with a steam identifier
    dprint("[find_clientID] Searching for client_id associated with : "..identifier)
    for _, Player in pairs(playerDB) do
        if Player.identifier == identifier then
            dprint('[find_clientID] found : '..Player.clientID)
            return Player.clientID
        end
    end
end

function addToSet(set, key)
    set[key] = true
end

function removeFromSet(set, key)
    set[key] = nil
end

function setContains(set, key)
    return set[key] ~= nil
end


--[[ edited (22.09.2020) by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]