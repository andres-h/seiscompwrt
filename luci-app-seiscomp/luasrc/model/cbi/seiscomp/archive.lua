-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local sl = require "luci.tools.seiscomp.seedlink"
local m = Map("seiscomp", "SeedLink")
local s = m:section(NamedSection, "archive", "archive", "Archive")

local o = s:option(Flag, "enabled", "enabled")
o.default = o.disabled
o.rmempty = false

local o = s:option(Value, "path", "path", "Path to waveform archive where data is stored.")
o.default = "/data/archive"

sl.fillsection(s, "binding", "slarchive")

return m

