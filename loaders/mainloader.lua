if not game:IsLoaded() then
    game.Loaded:Wait()
end

local players = game:GetService('Players')
local localPlayer = players.LocalPlayer
if not localPlayer then
    players:GetPropertyChangedSignal('LocalPlayer'):Wait()
    localPlayer = players.LocalPlayer
end

local placeid        =      game.PlaceId
local executor       =      identifyexecutor and identifyexecutor() or 'Unknown'
local request        =      request or http_request
local loadstring     =      loadstring

local protected = function(url)
    local success, response = pcall(request, {Url = url, Method = 'GET'})
    if not success or type(response) ~= 'table' or type(response.Body) ~= 'string' or response.StatusCode ~= 200 then
        return
    end
    local loader = loadstring(response.Body)
    if not loader then
        return
    end
    return loader()
end

local gamelist = {
    tridentsurvival = {
        name = 'Trident Survival',
        url = 'https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/main/tridentsurvival.lua',
        support = {'Wave', 'AWP', 'Synapse Z'}
    },
    phantomforces = {
        name = 'Phantom Forces',
        url = 'https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/main/phantomforces.lua',
        support = {'Wave', 'AWP', 'Synapse Z', 'Atlantis', 'Potassium'}
    },
    projectdelta = {
        name = 'Project Delta',
        url = 'https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/main/projectdelta.lua',
        support = {'Wave', 'AWP', 'Synapse Z','Velocity', 'Atlantis', 'Potassium'}
    },
    counterblox = {
        name = 'Counter Blox',
        url = 'https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/main/counterblox.lua',
        support = {'Wave', 'AWP', 'Synapse Z', 'Velocity', 'Atlantis', 'Potassium'}
    },
    universal = {
        name = 'Universal',
        url = 'https://raw.githubusercontent.com/guiddo806/viteck.gg/refs/heads/main/main/universal.lua', 
        support = {'Wave', 'AWP', 'Synapse Z', 'Velocity', 'Atlantis', 'Potassium'},
    },
}

local function supportedexecutor(exec, supportList)
    for _, supported in ipairs(supportList) do
        if exec == supported then
            return true
        end
    end
    return false
end

local load = function(name)
    local game = gamelist[name]
    if game.support and not supportedexecutor(executor, game.support) then
        return 
    end
    protected(game.url)
end

local function fetchplaceid()
    if placeid == 13253735473 then
        return load('tridentsurvival')
    elseif placeid == 301549746 then
        return load('counterblox')
    elseif placeid == 7336302630 then
        return load('projectdelta')
    end

    if gamelist.universal and gamelist.universal.url ~= '' then
        return load('universal')
    end
end

fetchplaceid()
