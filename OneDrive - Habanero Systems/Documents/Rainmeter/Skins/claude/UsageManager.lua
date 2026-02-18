-- UsageManager.lua
-- Reads Claude usage data from JSON cache and updates Rainmeter variables

function Initialize()
    UpdateUsage()
end

function Update()
    -- Called on each Rainmeter update cycle
    return 0
end

function UpdateUsage()
    local cachePath = os.getenv('USERPROFILE') .. '\\.claude\\usage-cache.json'
    local file = io.open(cachePath, 'r')

    if not file then
        -- No cache file yet, use defaults
        return
    end

    local content = file:read('*all')
    file:close()

    if not content or content == '' then
        return
    end

    -- Simple JSON parsing for our specific format
    local sessionPercent = content:match('"SessionPercent"%s*:%s*([%d%.%-]+)')
    local sessionReset = content:match('"SessionReset"%s*:%s*"([^"]*)"')
    local weeklyPercent = content:match('"WeeklyPercent"%s*:%s*([%d%.%-]+)')
    local weeklyReset = content:match('"WeeklyReset"%s*:%s*"([^"]*)"')
    local sonnetPercent = content:match('"SonnetPercent"%s*:%s*([%d%.%-]+)')
    local sonnetReset = content:match('"SonnetReset"%s*:%s*"([^"]*)"')
    local subscriptionType = content:match('"SubscriptionType"%s*:%s*"([^"]*)"')

    -- Update Rainmeter variables
    if sessionPercent then
        SKIN:Bang('!SetVariable', 'SessionPercent', sessionPercent)
    end
    if sessionReset then
        SKIN:Bang('!SetVariable', 'SessionReset', sessionReset)
    end
    if weeklyPercent then
        SKIN:Bang('!SetVariable', 'WeeklyPercent', weeklyPercent)
    end
    if weeklyReset then
        SKIN:Bang('!SetVariable', 'WeeklyReset', weeklyReset)
    end
    if sonnetPercent then
        SKIN:Bang('!SetVariable', 'SonnetPercent', sonnetPercent)
    end
    if sonnetReset then
        SKIN:Bang('!SetVariable', 'SonnetReset', sonnetReset)
    end

    -- Update subscription badge
    if subscriptionType then
        local badge = 'Pro'
        if subscriptionType == 'max' then
            badge = 'Max'
        end
        SKIN:Bang('!SetVariable', 'SubscriptionBadge', badge)
    end

    -- Refresh meters
    SKIN:Bang('!UpdateMeasure', '*')
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')
end

function FetchUsage()
    -- Trigger the PowerShell script to fetch fresh data
    local scriptPath = SKIN:GetVariable('CURRENTPATH') .. 'FetchUsage.ps1'
    SKIN:Bang('["powershell.exe" -ExecutionPolicy Bypass -WindowStyle Hidden -File "' .. scriptPath .. '"]')

    -- Wait a moment then update
    SKIN:Bang('!Delay', '2000')
    UpdateUsage()
end
