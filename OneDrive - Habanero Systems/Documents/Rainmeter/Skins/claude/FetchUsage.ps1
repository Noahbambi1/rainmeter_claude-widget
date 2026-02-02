# Claude Code Usage Fetcher for Rainmeter
# Fetches live usage data from Anthropic API and writes to JSON for Rainmeter to read

$ErrorActionPreference = "SilentlyContinue"

# Read credentials
$credPath = "$env:USERPROFILE\.claude\.credentials.json"
$outputPath = "$env:USERPROFILE\.claude\usage-cache.json"

try {
    $creds = Get-Content $credPath -Raw | ConvertFrom-Json
    $token = $creds.claudeAiOauth.accessToken

    if (-not $token) {
        Write-Error "No access token found"
        exit 1
    }

    # Fetch usage data from Anthropic API
    $headers = @{
        "Accept" = "application/json"
        "Content-Type" = "application/json"
        "User-Agent" = "claude-code/2.0.32"
        "Authorization" = "Bearer $token"
        "anthropic-beta" = "oauth-2025-04-20"
    }

    $response = Invoke-RestMethod -Uri "https://api.anthropic.com/api/oauth/usage" -Headers $headers -Method Get

    # Parse the response and calculate percentages
    $fiveHourUsage = 0
    $fiveHourResets = "Unknown"
    $sevenDayUsage = 0
    $sevenDayResets = "Unknown"
    $sonnetUsage = 0
    $sonnetResets = "Unknown"

    if ($response.five_hour) {
        # Utilization comes as percentage (e.g., 74.00 means 74%)
        $fiveHourUsage = [math]::Round($response.five_hour.utilization, 0)
        if ($response.five_hour.resets_at) {
            $resetTime = [DateTime]::Parse($response.five_hour.resets_at)
            $timeUntil = $resetTime - (Get-Date)
            if ($timeUntil.TotalMinutes -gt 60) {
                $fiveHourResets = "{0}h {1}m" -f [math]::Floor($timeUntil.TotalHours), $timeUntil.Minutes
            } else {
                $fiveHourResets = "{0} min" -f [math]::Round($timeUntil.TotalMinutes, 0)
            }
        }
    }

    if ($response.seven_day) {
        $sevenDayUsage = [math]::Round($response.seven_day.utilization, 0)
        if ($response.seven_day.resets_at) {
            $resetTime = [DateTime]::Parse($response.seven_day.resets_at)
            $sevenDayResets = $resetTime.ToString("ddd h:mm tt")
        }
    }

    if ($response.seven_day_sonnet) {
        $sonnetUsage = [math]::Round($response.seven_day_sonnet.utilization, 0)
        if ($response.seven_day_sonnet.resets_at) {
            $resetTime = [DateTime]::Parse($response.seven_day_sonnet.resets_at)
            $sonnetResets = $resetTime.ToString("ddd h:mm tt")
        }
    }

    # Create output object
    $output = @{
        SessionPercent = $fiveHourUsage
        SessionReset = $fiveHourResets
        WeeklyPercent = $sevenDayUsage
        WeeklyReset = $sevenDayResets
        SonnetPercent = $sonnetUsage
        SonnetReset = $sonnetResets
        LastUpdated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        SubscriptionType = $creds.claudeAiOauth.subscriptionType
        RateLimitTier = $creds.claudeAiOauth.rateLimitTier
    }

    # Write to JSON file
    $output | ConvertTo-Json | Out-File -FilePath $outputPath -Encoding UTF8

    Write-Host "Usage data updated successfully"
    Write-Host "Session: $fiveHourUsage% (resets in $fiveHourResets)"
    Write-Host "Weekly: $sevenDayUsage% (resets $sevenDayResets)"
    Write-Host "Sonnet: $sonnetUsage% (resets $sonnetResets)"

} catch {
    Write-Error "Failed to fetch usage data: $_"

    # Write error state
    @{
        SessionPercent = -1
        SessionReset = "Error"
        WeeklyPercent = -1
        WeeklyReset = "Error"
        LastUpdated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Error = $_.Exception.Message
    } | ConvertTo-Json | Out-File -FilePath $outputPath -Encoding UTF8
}
