-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local uci = require "uci"
local fs = require "nixio.fs"

local function status()
	local t = {}

	uci.cursor():foreach("scgpio", "gpio", function(s)
		if s.type ~= "switch" and s.type ~= "trigger" and s.type ~= "input" then
			io.stderr:write(s[".name"] .. ": invalid type \"" .. s.type .. "\"\n")
			return
		end

		local item = {
			name = s[".name"],
			type = s.type,
			description = s.description or "",
			init_state = tonumber(s.init_state) or 0,
			duration = tonumber(s.duration) or 1.0
		}

		table.insert(t, item)

		local buf, _, err = fs.readfile("/sys/class/gpio/" .. s[".name"] .. "/value")
		if not buf then
			item.error = err
			return
		end

		local value = tonumber(buf)
		if value ~= 0 and value ~= 1 then
			item.error = "invalid state"
			return
		end

		item.state = value
	end)

	return t
end

local function set(name, value)
	local s = uci.cursor():get_all("scgpio", name)

	if s.type ~= "switch" and s.type ~= "trigger" then
		return nil, "invalid GPIO"
	end

	if value ~= 0 and value ~= 1 then
		return nil, "invalid state"
	end

	local res, _, err = fs.writefile("/sys/class/gpio/" .. s[".name"] .. "/value", value)
	if not res then
		return nil, err
	end

	return true
end

return {
	status = status,
	set = set
}

