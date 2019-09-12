-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local dsp = require "luci.dispatcher"
local stream = arg[1] or ""

local m = Map("seiscomp", "SeedLink")
m.redirect = dsp.build_url("admin", "services", "seedlink", "stream")

local s = m:section(NamedSection, stream, "stream", stream)

local o = s:option(Value, "description", "description", "Description.")
o.rmempty = false
o.datatype = "rangelength(1, 100)"

local o = s:option(Value, "unit", "unit", "Unit.")
o.default = "counts"

local o = s:option(Value, "conversion", "conversion", "Conversion formula.")
o.default = "counts"

local o = s:option(Flag, "live", "live", "Enable live seismogram.")
o.default = o.disabled

local o = s:option(Flag, "hidden", "hidden", "Not shown on status page.")
o.default = o.disabled

return m

