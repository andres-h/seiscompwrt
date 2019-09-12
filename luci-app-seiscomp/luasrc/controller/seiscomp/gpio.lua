-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

module("luci.controller.seiscomp.gpio", package.seeall)

local gpio = require "luci.tools.seiscomp.gpio"

function index()
	entry({"admin", "status", "gpio"}, template("seiscomp/gpio"), "GPIO", 910)
	entry({"admin", "services", "gpio"}, alias("admin", "services", "gpio", "pin"), "GPIO", 910)
	entry({"admin", "services", "gpio", "pin"}, arcombine(cbi("seiscomp/gpio"), cbi("seiscomp/gpioconfig")), "Pins", 10).leaf = true
	entry({"admin", "services", "gpio", "monitor"}, cbi("seiscomp/gpiomonitor"), "Monitor", 20)
	entry({"admin", "services", "gpio", "set"}, call("gpio_set"))
end

function gpio_set()
	luci.http.prepare_content("application/json")

	local name = luci.http.formvalue("name")
	local value = tonumber(luci.http.formvalue("value"))

	if not name or not value then
		luci.http.write_json{error = "invalid parameters"}
		return
	end

	local res, err = gpio.set(name, value)
	if res then
		luci.http.write_json{}
	else
		luci.http.write_json{error = err}
	end
end

