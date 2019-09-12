-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local dsp = require "luci.dispatcher"
local sl = require "luci.tools.seiscomp.seedlink"
local src = arg[1] or ""
local srcdesc = src
local srctype, srcnum = src:match("^(.*)_([^_]*)$")

local m = Map("seiscomp", "SeedLink")
m.redirect = dsp.build_url("admin", "services", "seedlink", "source")

if not srctype then
	return m
end

for _, v in ipairs(sl.sourcetypes()) do
	if v.name == srctype then
		srcdesc = v.description .. " #" .. srcnum
	end
end

local s = m:section(NamedSection, src, "source", srcdesc)

local o = s:option(Flag, "enabled", "enabled")
o.default = o.enabled
o.rmempty = false

sl.fillsection(s, "binding", "seedlink", srctype)

return m

