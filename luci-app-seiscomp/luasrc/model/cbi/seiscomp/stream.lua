-- (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

local dsp = require "luci.dispatcher"
local m = Map("seiscomp", "SeedLink")

local s = m:section(TypedSection, "stream", "Streams")
s.sectionhead = "Name"
s.add_title = "Add new stream"
s.addremove = true
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = dsp.build_url("admin", "services", "seedlink", "stream", "%s")

function s:create(section)
	if (#section ~= 3 and #section ~= 5) or not section:match("^[A-Z0-9]*$") then
		s.invalid_cts = true
		return
	end

	TypedSection.create(self, section)
	m.uci:save("seiscomp")
	luci.http.redirect(dsp.build_url("admin", "services", "seedlink", "stream", section))
end

s:option(DummyValue, "description", "Description")
s:option(DummyValue, "unit", "Unit")

local o = s:option(DummyValue, "live", "Live")
function o:cfgvalue(s)
	if self.map:get(s, "live") == "1" then
		return "Yes"
	else
		return "No"
	end
end

local o = s:option(DummyValue, "hidden", "Hidden")
function o:cfgvalue(s)
	if self.map:get(s, "hidden") == "1" then
		return "Yes"
	else
		return "No"
	end
end

return m

