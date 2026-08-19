local Colors = {
    Green = "0,255,0,255",
    Yellow = "255,255,0,255",
    Red = "255,0,0,255",
}
local function pickColor(value, lo, hi)
    if value >= hi then return Colors.Red
    elseif value >= lo then return Colors.Yellow
    else return Colors.Green
    end
end

local function setColor(meter, color)
    SKIN:Bang('!SetOption ' .. meter .. ' FontColor ' .. color)
end

function UptimeFormatted()
    local uptime = SKIN:GetMeasure('MeasureUptimeRaw'):GetValue()

    local days    = math.floor(uptime / 86400)
    local hours   = math.floor((uptime % 86400) / 3600)
    local minutes = math.floor((uptime % 3600) / 60)
    local seconds = math.floor(uptime % 60)

    setColor('MeterUptime', pickColor(days, 3, 7))

    return string.format("%dไ %02d:%02d:%02d", days, hours, minutes, seconds)
end

function VRAMUsed()
    local bytes = SKIN:GetMeasure('MeasureVRAM'):GetValue()
    local total = SKIN:GetMeasure('MeasureTotalVRAM'):GetValue()

    local pct = (bytes / total) * 100

    setColor('MeterVRAM', pickColor(pct, 50, 75))
    SKIN:Bang('!UpdateMeter MeterVRAM')

    return string.format("%.2f", bytes / 1073741824)
end

function RAMUsed()
    local measure  = SKIN:GetMeasure('MeasureRAMUsedGB')
    local bytes    = measure:GetValue()
    local total    = measure:GetMaxValue()

    local pct      = (bytes / total) * 100
    local used_gb  = bytes / 1073741824
    local total_gb = total / 1073741824
    local pct_int  = math.floor(pct + 0.5)

    setColor('MeterRAM', pickColor(pct, 50, 75))
    SKIN:Bang('!UpdateMeter MeterRAM')

    return string.format("%s/%s รม (%d/100%%)",
        string.format("%.1f", used_gb),
        string.format("%.1f", total_gb),
        pct_int)
end

function Update()
    local name = SELF:GetName()
    if     name == "MeasureScriptUptime" then return UptimeFormatted()
    elseif name == "MeasureScriptVRAM"   then return VRAMUsed()
    elseif name == "MeasureScriptRAMGB"  then return RAMUsed()
    else   return "Unknown measure: " .. tostring(name)
    end
end