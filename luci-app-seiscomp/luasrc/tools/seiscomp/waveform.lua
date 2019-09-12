-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local uci = require "uci"
local socket = require "socket"

local function fetch(streams, seq, starttime, endtime)
	local u = uci.cursor()

	local port = tonumber(u:get("seiscomp", "seedlink", "port"))
	if not port then
		return nil, "missing seedlink port"
	end

	local network = u:get("seiscomp", "seedlink", "network")
	if not network then
		return nil, "missing network code"
	end

	local station = u:get("seiscomp", "seedlink", "station")
	if not station then
		return nil, "missing station code"
	end

	local sock, res, err

	sock, err = socket.tcp()
	if not sock then
		return nil, err
	end

	sock:settimeout(10)

	res, err = sock:connect("localhost", port)
	if not res then
		sock:close()
		return nil, err
	end

	res, err = sock:send("STATION " .. station .. " " .. network .. "\r\n")
	if not res then
		sock:close()
		return nil, err
	end

	res, err = sock:receive()
	if not res then
		sock:close()
		return nil, err
	end

	if res:match("^%s*(.-)%s*$") ~= "OK" then
		sock:close()
		return nil, "station not accepted"
	end

	for str in streams:gmatch("([^,]+)") do
		res, err = sock:send("SELECT " .. str .. ".D\r\n")
		if not res then
			sock:close()
			return nil, err
		end

		res, err = sock:receive()
		if not res then
			sock:close()
			return nil, err
		end

		if res:match("^%s*(.-)%s*$") ~= "OK" then
			sock:close()
			return nil, "SELECT command not accepted"
		end
	end

	if starttime and endtime and not seq then
		res, err = sock:send("TIME " .. starttime .. " " .. endtime .. "\r\n")

	elseif starttime then
		res, err = sock:send("FETCH " .. (seq or 0) .. " " .. starttime .. "\r\n")

	elseif seq then
		res, err = sock:send("FETCH " .. seq .. "\r\n")

	else
		res, err = sock:send("FETCH\r\n")
	end

	if not res then
		sock:close()
		return nil, err
	end

	res, err = sock:receive()
	if not res then
		sock:close()
		return nil, err
	end

	if res:match("^%s*(.-)%s*$") ~= "OK" then
		sock:close()
		return nil, "FETCH or TIME command not accepted"
	end

	res, err = sock:send("END\r\n")
	if not res then
		sock:close()
		return nil, err
	end

	local buf = {}

	for i = 1, 1024 do
		res, err = sock:receive(3)
		if not res or res == "END" then
			break
		end

		table.insert(buf, res)

		res, err = sock:receive(517)
		if not res then
			break
		end

		table.insert(buf, res)
	end

	sock:close()

	return table.concat(buf)
end

return {
	fetch = fetch
}

