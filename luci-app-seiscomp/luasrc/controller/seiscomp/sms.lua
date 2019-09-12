-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

module("luci.controller.seiscomp.sms", package.seeall)

function index()
	entry({"admin", "status", "sms"}, template("seiscomp/sms"), "SMS", 920)
	entry({"admin", "services", "sms"}, cbi("seiscomp/sms"), "SMS", 920)
end

