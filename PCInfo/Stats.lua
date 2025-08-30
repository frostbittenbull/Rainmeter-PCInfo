function UptimeFormatted()
    local uptime = SKIN:GetMeasure('MeasureUptimeRaw'):GetValue()

    local days = math.floor(uptime / 86400)
    local hours = math.floor((uptime % 86400) / 3600)
    local minutes = math.floor((uptime % 3600) / 60)
    local seconds = math.floor(uptime % 60)

    if days >= 7 then
        SKIN:Bang('!SetOption MeterUptime FontColor "255,0,0,255"')
    elseif days >= 3 then
        SKIN:Bang('!SetOption MeterUptime FontColor "255,255,0,255"')
    else
        SKIN:Bang('!SetOption MeterUptime FontColor "0,255,0,255"')
    end

    return string.format("%dä %02d:%02d:%02d", days, hours, minutes, seconds)
end

function RAMUsed()
    local bytes = SKIN:GetMeasure('MeasureRAMUsed'):GetValue()
    local gb = bytes / 1073741824
    local formatted = string.format("%.2f", gb)

    if gb <= 8.00 then
        SKIN:Bang('!SetOption MeterRAMUsed FontColor "0,255,0,255"')
    elseif gb <= 12.00 then
        SKIN:Bang('!SetOption MeterRAMUsed FontColor "255,255,0,255"')
    else
        SKIN:Bang('!SetOption MeterRAMUsed FontColor "255,0,0,255"')
    end

    SKIN:Bang('!UpdateMeter MeterRAMUsed')
    SKIN:Bang('!Redraw')

    return formatted
end

function Update()
    local name = SELF:GetName()
    if name == "MeasureScriptUptime" then
        return UptimeFormatted()
    elseif name == "MeasureScriptRAM" then
        return RAMUsed()
    else
        return "Unknown measure: "..tostring(name)
    end
end