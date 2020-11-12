function formatNumber(number, padding)
  return string.format("%0" .. padding .. "d", number)
end

function formatTime(seconds)
  return formatNumber(math.floor(seconds / 60), 2) .. ":" .. formatNumber(seconds % 60, 2)
end

function formatSpeed(speed, negative, positive)
  local icons = {
    ["horizontal speed"] = {"←", "→"},
    ["vertical speed"] = {"↑", "↓"}
  }
  local icon = ""
  if speed > 0 then
    icon = positive
  elseif speed < 0 then
    icon = negative
  end

  return math.abs(speed) .. " " .. icon
end

function formatKeyValuePair(key, value, whitespace)
  return string.upper(key) .. string.format("%" .. whitespace .. "s", " ") .. value
end
