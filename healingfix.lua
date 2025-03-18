local log     =   game:GetService("LogService")
local value   =   100

local function increment()
    while true do
        if value < 100 then
            wait(5)
            value = math.min(value + 1, 100)
        end
        wait(5)
    end
end

coroutine.wrap(increment)()

local function reset()
    while true do
        if value <= 1 then
            wait(1)
            value = 100
        end
        wait(1)
    end
end

coroutine.wrap(reset)()

local function logmessage(message)
    local health = message:match("->(%d+%.?%d*)hp")
    health = tonumber(health)
    if health then
        value = math.floor(health)
    end
end

log.MessageOut:Connect(logmessage)
