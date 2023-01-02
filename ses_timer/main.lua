function()
	result = {}
	-- result.start_hour = os.date("%I") -- defining start hour
	result.start_hour = os.date("%I")
	result.start_min = os.date("%M") -- defining start min
	result.status = function(hour, min)
		local time = os.time({ day = 1, year = 1, month = 1, hour = hour, min = min })
		return os.date("%p", time)
	end
	result.format_below10 = function(time) --time refers to hour/min
		return "0" .. tostring(time)
	end
	result.format_min_past60 = function(hour, min)
		min = min - 60
		hour = hour + 1
		return hour, min
	end
	result.format_hour_past12 = function(hour)
		return hour - 12
	end
	result.format = function(hour, min)
		if min < 10 then
			result.end_min = result.format_below10(min)
		end
		if min >= 60 then
			result.end_hour, result.end_min = result.format_min_past60(hour, min)
			print(result.end_hour)
		end
		--as the end_hour gets modifed in the upper cond, i need to check for the global val
		--instead of the value passed as a param
		if result.end_hour > 12 then
			result.end_hour = result.format_hour_past12(result.end_hour)
		end
        return result.end_time()
	end
	result.adder = function(session_duration)
		local ses_hour = string.sub(session_duration, 1, 1)
		local ses_min = string.sub(session_duration, 3, 4)
		return tonumber(result.start_hour) + tonumber(ses_hour), tonumber(result.start_min) + tonumber(ses_min)
		-- result.format(result.end_hour,result.end_min)
	end
	result.end_time = function()
		return result.end_hour .. ":" .. result.end_min .. result.status(result.end_hour, result.end_min)
	end
	result.start_time = function()
		return result.start_hour .. ":" .. result.start_min .. result.status(result.start_hour, result.start_min)
	end
    result.init = function ()
		local session_duration = vim.fn.input("Enter session duration (H:M) = ")
        result.end_hour, result.end_min = result.adder(session_duration)
        local end_time = result.format(result.end_hour,result.end_min)
		return "{" .. session_duration .. " H}" .. " [ " .. result.start_time() .. " -> " .. end_time .. " ]"

    end
    return result.init()
end
print(x())
-- x()
