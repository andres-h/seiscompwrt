-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local sl = require "luci.tools.seiscomp.seedlink"
local m = Map("seiscomp", "SeedLink")
local s = m:section(NamedSection, "seedlink", "seedlink", "Globals")

local o = s:option(Flag, "enabled", "enabled")
o.default = o.disabled
o.rmempty = false

local o = s:option(Value, "description", "description", "Station description.")
o.default = "SeiscompWrt"

local o = s:option(Value, "network", "network", "Network code.")
o.datatype = "rangelength(1, 2)"
o.rmempty = false

local o = s:option(Value, "station", "station", "Station code.")
o.datatype = "rangelength(1, 5)"
o.rmempty = false

sl.fillsection(s, "module", "seedlink")

for _, v in ipairs(sl.sourcetypes()) do
	sl.fillsection(s, "plugin", "seedlink", v.name)
end

local o = s:option(Flag, "syslog", "syslog", "Use syslog when supported.")
o.enabled = "true"
o.disabled = "false"
o.default = o.disabled

return m

