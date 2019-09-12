-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

module("luci.controller.seiscomp.seedlink", package.seeall)

local wave = require "luci.tools.seiscomp.waveform"

function index()
	entry({"admin", "status", "seedlink"}, alias("admin", "status", "seedlink", "live"), "SeedLink", 900)
	entry({"admin", "status", "seedlink", "live"}, template("seiscomp/liveplot"), "Live", 10)
	entry({"admin", "status", "seedlink", "soh"}, template("seiscomp/sohplot"), "SOH", 20)
	entry({"admin", "services", "seedlink"}, alias("admin", "services", "seedlink", "globals"), "SeedLink", 900)
	entry({"admin", "services", "seedlink", "globals"}, cbi("seiscomp/seedlink"), "Globals", 10)
	entry({"admin", "services", "seedlink", "source"}, arcombine(cbi("seiscomp/source"), cbi("seiscomp/sourceconfig")), "Sources", 20).leaf = true
	entry({"admin", "services", "seedlink", "stream"}, arcombine(cbi("seiscomp/stream"), cbi("seiscomp/streamconfig")), "Streams", 30).leaf = true
	entry({"admin", "services", "seedlink", "archive"}, cbi("seiscomp/archive"), "Archive", 40)
	entry({"admin", "services", "seedlink", "fetch"}, call("seedlink_fetch"))
end

function seedlink_fetch()
	local stream = luci.http.formvalue("stream")
	local seq = luci.http.formvalue("seq")
	local starttime = luci.http.formvalue("start")
	local endtime = luci.http.formvalue("end")

	if not stream then
		luci.http.prepare_content("text/plain")
		luci.http.write("invalid parameters")
		return
	end

	local res, err = wave.fetch(stream, seq, starttime, endtime)
	if res then
		luci.http.prepare_content("application/octet-stream")
		luci.http.write(res)
	else
		luci.http.prepare_content("text/plain")
		luci.http.write(err)
	end
end

