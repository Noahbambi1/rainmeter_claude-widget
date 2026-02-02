function Initialize()
    ApplyTheme()
end

function ApplyTheme()
    local theme = tonumber(SKIN:GetVariable('CurrentTheme'))

    -- Theme definitions
    local themes = {
        -- Dark Theme (0)
        {
            AccentOrange = '217,119,87',
            TextBright = '255,255,255',
            TextColor = '230,230,235',
            TextMuted = '160,160,170',
            TextDim = '100,100,115',
            BgDeep = '15,15,25',
            BgCard = '32,32,48',
            BgProject = '40,40,58',
            BgProjectHover = '55,55,75',
            BorderColor = '80,80,100',
            GreenAccent = '52,211,153',
            BlueAccent = '96,165,250',
            PurpleAccent = '167,139,250',
            PinkAccent = '244,114,182',
            CyanAccent = '34,211,238'
        },
        -- Light Theme (1)
        {
            AccentOrange = '200,80,40',
            TextBright = '30,30,40',
            TextColor = '50,50,60',
            TextMuted = '90,90,110',
            TextDim = '120,120,140',
            BgDeep = '245,245,250',
            BgCard = '255,255,255',
            BgProject = '235,235,245',
            BgProjectHover = '225,225,240',
            BorderColor = '200,200,210',
            GreenAccent = '16,163,127',
            BlueAccent = '59,130,246',
            PurpleAccent = '124,58,237',
            PinkAccent = '219,39,119',
            CyanAccent = '6,182,212'
        },
        -- Neon Theme (2)
        {
            AccentOrange = '255,100,150',
            TextBright = '255,255,255',
            TextColor = '220,220,240',
            TextMuted = '170,150,190',
            TextDim = '120,100,140',
            BgDeep = '15,10,30',
            BgCard = '30,20,50',
            BgProject = '40,25,65',
            BgProjectHover = '55,35,85',
            BorderColor = '80,50,120',
            GreenAccent = '0,255,180',
            BlueAccent = '100,180,255',
            PurpleAccent = '180,100,255',
            PinkAccent = '255,80,180',
            CyanAccent = '0,220,255'
        }
    }

    -- Apply the selected theme (theme is 0-indexed in Lua array, so add 1)
    local selectedTheme = themes[theme + 1]
    if selectedTheme then
        for key, value in pairs(selectedTheme) do
            SKIN:Bang('!SetVariable', key, value)
        end
    end

    -- Refresh all meters
    SKIN:Bang('!UpdateMeasure', '*')
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')
end

function CycleTheme()
    local currentTheme = tonumber(SKIN:GetVariable('CurrentTheme'))
    local newTheme = (currentTheme + 1) % 3
    SKIN:Bang('!SetVariable', 'CurrentTheme', newTheme)
    ApplyTheme()
    return newTheme
end
