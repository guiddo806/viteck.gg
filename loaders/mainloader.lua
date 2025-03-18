if not game:IsLoaded() then
    game.Loaded:Wait()
end

local players = game:GetService('Players')
local localPlayer = players.LocalPlayer
if not localPlayer then
    players:GetPropertyChangedSignal('LocalPlayer'):Wait()
    localPlayer = players.LocalPlayer
end

local executor = identifyexecutor and identifyexecutor() or 'Unknown'
local request = request or http_request
local loadstring = loadstring

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

local placeid = game.PlaceId

local gamelist = {
    counterblox = {
        name = 'Counter Blox',
        url = 'https://raw.githubusercontent.com/tamerlan806/cbro/refs/heads/main/loader.lua',
        support = {'Wave', 'AWP', 'Synapse Z', 'Velocity', 'Atlantis', 'Potassium'}
    },
    tridentsurvival = {
        name = 'Trident Survival',
        url = '',
        support = {'Wave', 'AWP', 'Synapse Z', 'Atlantis', 'Potassium'}
    },
    universal = {
        name = 'Universal',
        url = '', 
        support = {'Wave', 'AWP', 'Synapse Z', 'Velocity', 'Atlantis', 'Potassium', 'Xeno', 'Solara', 'Luna', 'Argon'},
      --universal = true
    }
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

local function FetchPlaceID()
    if placeid == 13253735473 then
        return load('tridentsurvival')
    elseif placeid == 301549746 then
        return load('counterblox')
    end
    
    if gamelist.universal and gamelist.universal.url ~= '' then
        return load('universal')
    end
end

FetchPlaceID()
